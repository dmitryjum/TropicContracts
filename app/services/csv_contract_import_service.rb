class CsvContractImportService
  require 'csv'
  # HEADERS = {
  #   "Contract Owner" => 0,
  #   "External Contract ID" => 1,
  #   "Contract Name" => 2,
  #   "Start Date" => 3,
  #   "End Date" => 4,
  #   "Contract Value" => 5,
  #   "Supplier" => 6
  # }

  # attr_reader :invalid_contract_instances, :updated_contracts_counter, :result_batches
  def initialize(file, session_id)
    # csv_array.shift
    # @csv_array = csv_array
    # @updated_contracts_counter = 0
    # @invalid_contract_instances = []
    # @result_batches = []
    @file = file
    @session_id = session_id
    # @flash = {}
  end

  def call
    # the method below should be implemented in this service:
    # ContractImportJob should take batch_array,
    # session_id and updated_contracts_counter (add to arg every time),
    # invalid_contract_instances array of error strings, updated on every job
    CsvContractImportJob.perform_later(csv_array:, session_id: @session_id)
    @csv_array.each_slice(500) do |batch| # these batches have to be performed as a background job
      emails = get_unique_emails(batch)
      owners = create_and_return_owners(emails)
      @result_batches << upsert_contracts(owners, batch)
      # ContractImportJob.perform should be called on this line inside itself with sliced batch, or the next slice -- figure it out
    end
    
    # the code block below would go to the end of #upsert_contracts method
    if @updated_contracts_counter > 0
      @flash[:notice] = "#{@updated_contracts_counter} records have been created or updated successfuly"
      Turbo::StreamsChannel.broadcast_replace_to("csv_import_#{@session_id}", target: "contracts", html: rendered_contract_row_component)
    else
      @flash[:notice] = "No contracts have been updated or created"
    end
    Turbo::StreamsChannel.broadcast_replace_to("flash_#{@session_id}", target: "flash", html: rendered_flash_component)
  end
  
  private

   def csv_array
    file = File.open(@file)
    table = CSV.parse(file, headers: true)
    table.to_a
  end
  
  # def get_unique_emails(batch)
  #   batch.map {|row| row[HEADERS["Contract Owner"]]}.compact.uniq
  # end
  
  # def create_and_return_owners(emails)
  #   owners_hashes = emails.map do |email|
  #     split_email = email.split(/\.|@/)
  #     {
  #       first_name: split_email[0].capitalize,
  #       last_name: split_email[1].capitalize,
  #       email: email
  #     }
  #   end

  #   ContractOwner.upsert_all(
  #     owners_hashes,
  #     unique_by: [:email, :index_contract_owners_on_email],
  #     returning: [:email, :id],
  #     update_only: [:first_name, :last_name]
  #   )
  # end
  
  # def upsert_contracts(owners, batch)
  #   valid_contract_hashes = []

  #   batch.each do |row|
  #     time = Time.current
  #     start_date = Date.strptime(row[HEADERS["Start Date"]], '%m/%d/%Y') unless row[HEADERS["Start Date"]].nil?
  #     end_date = Date.strptime(row[HEADERS["End Date"]], '%m/%d/%Y') unless row[HEADERS["End Date"]].nil?
  #     contract_hash = {
  #       external_contract_id: row[HEADERS["External Contract ID"]],
  #       name: row[HEADERS["Contract Name"]],
  #       start_date: start_date,
  #       end_date: end_date,
  #       value_cents: row[HEADERS["Contract Value"]].try(:gsub, /\D/, '').try(:to_i),
  #       supplier: row[HEADERS["Supplier"]],
  #       updated_at: time,
  #       created_at: time,
  #       contract_owner_id: owners.rows.to_h[row[HEADERS["Contract Owner"]]]
  #     }
  #     contract_instance = initialize_to_validate(contract_hash)

  #     unless contract_instance.valid?
  #       @invalid_contract_instances << contract_instance #an arror string should be pushd instead of the instance to a passed argument
  #       @flash[:alert] = {invalid_records: @invalid_contract_instances}
  #       Turbo::StreamsChannel.broadcast_replace_to("flash_#{@session_id}", target: "flash", html: rendered_flash_component)
  #     else
  #       valid_contract_hashes << contract_hash
  #     end
  #   end

  #   result = Contract.upsert_all(
  #     valid_contract_hashes,
  #     unique_by: [:external_contract_id, :index_contracts_on_external_contract_id],
  #     returning: [:name, :start_date, :end_date, :value_cents, :supplier, :contract_owner_id]
  #   )
  #   @updated_contracts_counter += result.length
  #   result
  # end

  # def initialize_to_validate(hash)
  #   contract = Contract.find_or_initialize_by(external_contract_id: hash[:external_contract_id])
  #   contract.assign_attributes(hash)
  #   contract
  # end

  # def rendered_flash_component
  #   ApplicationController.render(
  #     FlashComponent.new(notice: @flash[:notice], alert: @flash[:alert]), layout: false
  #   )
  # end

  # def rendered_contract_row_component
  #   ApplicationController.render(
  #     ContractRowComponent.with_collection(Contract.includes(:contract_owner)), layout: false
  #   )
  # end
end