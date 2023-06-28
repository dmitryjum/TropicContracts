class CsvContractImportService
  require 'csv'
  attr_reader :invalid_contract_instances, :updated_contracts_counter, :result_batches
  def initialize(file)
    @opened_file = File.open(file)
    @updated_contracts_counter = 0
    @invalid_contract_instances = []
    @result_batches = []
  end

  def call
    table = CSV.parse(@opened_file, headers: true)
    table.each_slice(500) do |batch|
      emails = get_unique_emails(batch)
      owners = create_and_return_owners(emails)
      @result_batches << upsert_contracts(owners, batch)
    end
  end
  
  private
  
  def get_unique_emails(batch)
    batch.map {|row| row["Contract Owner"]}.compact.uniq
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
  
  def upsert_contracts(owners, batch)
    valid_contract_hashes = []

    batch.each do |row|
      time = Time.current
      start_date = Date.strptime(row["Start Date"], '%m/%d/%Y') unless row["Start Date"].nil?
      end_date = Date.strptime(row["End Date"], '%m/%d/%Y') unless row["End Date"].nil?
      contract_hash = {
        external_contract_id: row["External Contract ID"],
        name: row["Contract Name"],
        start_date: start_date,
        end_date: end_date,
        value_cents: row["Contract Value"].try(:gsub, /\D/, '').try(:to_i),
        supplier: row["Supplier"],
        updated_at: time,
        created_at: time,
        contract_owner_id: owners.rows.to_h[row["Contract Owner"]]
      }
      contract_instance = initialize_to_validate(contract_hash)

      unless contract_instance.valid?
        @invalid_contract_instances << contract_instance
      else
        valid_contract_hashes << contract_hash
      end
    end

    result = Contract.upsert_all(
      valid_contract_hashes,
      unique_by: [:external_contract_id, :index_contracts_on_external_contract_id],
      returning: [:name, :start_date, :end_date, :value_cents, :supplier, :contract_owner_id]
    )
    @updated_contracts_counter += result.length
    result
  end

  def initialize_to_validate(hash)
    contract = Contract.find_or_initialize_by(external_contract_id: hash[:external_contract_id])
    contract.assign_attributes(hash)
    contract
  end
end