class CsvContractImportJob < ApplicationJob
  # include Sidekiq::Job
  queue_as :csv_import

  HEADERS = {
    "Contract Owner" => 0,
    "External Contract ID" => 1,
    "Contract Name" => 2,
    "Start Date" => 3,
    "End Date" => 4,
    "Contract Value" => 5,
    "Supplier" => 6
  }

  def perform(csv_array:, session_id:, updated_contracts_counter: 0, validation_errors: {})
    if csv_array.length > 0
      batch = csv_array.shift(3)
      emails = get_unique_emails(batch)
      owners = create_and_return_owners(emails)
      recursive_values = upsert_contracts(owners, batch, session_id, updated_contracts_counter, validation_errors)
      if csv_array.length > 0
        perform(csv_array:, session_id:, updated_contracts_counter: recursive_values[:counter], validation_errors: recursive_values[:invalid])
      end
      #DEBUG TODO: something's happening with flash messages: they don't persist on every batch, but replace each batch of flashes
      # successfuly updated contract counter doesn't add up either
      if recursive_values[:counter] > 0
        recursive_values[:flash][:notice] = "#{recursive_values[:counter]} records have been created or updated successfuly"
        Turbo::StreamsChannel.broadcast_replace_to("csv_import_#{session_id}", target: "contracts", html: rendered_contract_row_component)
      else
        recursive_values[:flash][:notice] = "No contracts have been updated or created"
      end
      Turbo::StreamsChannel.broadcast_replace_to("flash_#{session_id}", target: "flash", html: rendered_flash_component(flash: recursive_values[:flash]))
    else
      flash = {alert: "Your csv file must be empty!"}
      Turbo::StreamsChannel.broadcast_replace_to("flash_#{session_id}", target: "flash", html: rendered_flash_component(flash:))
    end
  end

  private

  def get_unique_emails(batch)
    batch.map {|row| row[HEADERS["Contract Owner"]]}.compact.uniq
  end
  
  def create_and_return_owners(emails)
    owners_hashes = emails.map do |email|
      split_email = email.split(/\.|@/)
      {
        first_name: split_email[0].capitalize,
        last_name: split_email[1].capitalize,
        email: email
      }
    end

    ContractOwner.upsert_all(
      owners_hashes,
      unique_by: [:email, :index_contract_owners_on_email],
      returning: [:email, :id],
      update_only: [:first_name, :last_name]
    )
  end

  def upsert_contracts(owners, batch, session_id, updated_contracts_counter, validation_errors)
    valid_contract_hashes = []
    validation_errors = {}
    flash = {}

    batch.each do |row|
      time = Time.current
      start_date = Date.strptime(row[HEADERS["Start Date"]], '%m/%d/%Y') unless row[HEADERS["Start Date"]].nil?
      end_date = Date.strptime(row[HEADERS["End Date"]], '%m/%d/%Y') unless row[HEADERS["End Date"]].nil?
      contract_hash = {
        external_contract_id: row[HEADERS["External Contract ID"]],
        name: row[HEADERS["Contract Name"]],
        start_date: start_date,
        end_date: end_date,
        value_cents: row[HEADERS["Contract Value"]].try(:gsub, /\D/, '').try(:to_i),
        supplier: row[HEADERS["Supplier"]],
        updated_at: time,
        created_at: time,
        contract_owner_id: owners.rows.to_h[row[HEADERS["Contract Owner"]]]
      }
      contract_instance = initialize_to_validate(contract_hash)
      unless contract_instance.valid?
        validation_errors[contract_instance.external_contract_id] = contract_instance.errors.full_messages
        flash[:alert] = {invalid_records: validation_errors}
        Turbo::StreamsChannel.broadcast_replace_to("flash_#{session_id}", target: "flash", html: rendered_flash_component(flash:))
      else
        valid_contract_hashes << contract_hash
      end
    end

    if valid_contract_hashes.length > 0
      result = Contract.upsert_all(
        valid_contract_hashes,
        unique_by: [:external_contract_id, :index_contracts_on_external_contract_id],
        returning: [:name, :start_date, :end_date, :value_cents, :supplier, :contract_owner_id]
      )
      updated_contracts_counter += result.length
    end

    { counter: updated_contracts_counter, invalid: validation_errors, flash: }
  end

  def initialize_to_validate(hash)
    contract = Contract.find_or_initialize_by(external_contract_id: hash[:external_contract_id])
    contract.assign_attributes(hash)
    contract
  end

  def rendered_flash_component(flash: {})
    ApplicationController.render(
      FlashComponent.new(notice: flash[:notice], alert: flash[:alert]), layout: false
    )
  end

  def rendered_contract_row_component
    ApplicationController.render(
      ContractRowComponent.with_collection(Contract.includes(:contract_owner)), layout: false
    )
  end
end
