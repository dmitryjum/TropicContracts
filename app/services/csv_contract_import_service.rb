class CsvContractImportService
  def initialize(file)
    @opened_file = File.open(file)
  end

  def call
    options = {
        header: :use,
        parse_empty_fields_as: :nil
      }
    Rcsv.parse(@opened_file, options).each_slice(500) do |batch|
      emails = get_unique_emails(batch)
      owners = create_and_return_owners(emails)
    end
  end
    
  private
  
  def get_unique_emails(batch)
    batch.map {|row| row[0]}.compact.uniq
  end

  def create_and_return_owners(emails)
    owners_array = emails.map do |email|
      split_email = email.split(/\.|@/)
      {
        first_name: split_email[0],
        last_name: split_email[1],
        email: email
      }
    end
    debugger
  end
end