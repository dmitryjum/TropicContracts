class CsvContractImportService
  require 'csv'
  def initialize(file)
    @opened_file = File.open(file)
  end

  def call
    table = CSV.parse(@opened_file, headers: true)
    table.each_slice(500) do |batch|
      emails = get_unique_emails(batch)
      owners = create_and_return_owners(emails)
      contracts = upsert_contracts(owners, batch)
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
        first_name: split_email[0],
        last_name: split_email[1],
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
    contract_hashes = batch.map do |row|
      time = Time.current
      {
        external_contract_id: row["External Contract ID"],
        name: row["Contract Name"],
        start_date: row["Start Date"],
        end_date: row["End Date"],
        value_cents: row["Contract Value"].try(:gsub, /\D/, '').try(:to_i),
        supplier: row["Supplier"],
        updated_at: time,
        created_at: time,
        contract_owner_id: owners.rows.to_h[row["Contract Owner"]]
      }
    end

    contracts = Contract.upsert_all(
      contract_hashes,
      unique_by: [:external_contract_id, :index_contracts_on_external_contract_id],
      returning: [:name, :start_date, :end_date, :value_cents, :supplier, :contract_owner_id]
      # update_only: [:name, :start_date, :end_date, :value_cents, :supplier, :contract_owner_id]
    )
    debugger
  end
end