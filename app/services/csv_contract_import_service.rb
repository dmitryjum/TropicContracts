class CsvContractImportService
  require 'csv'
  def initialize(file, session_id)
    @file = file
    @session_id = session_id
  end

  def call
    CsvContractImportJob.perform_later(csv_array:, session_id: @session_id)
  end
  
  private

   def csv_array
    file = File.open(@file)
    table = CSV.parse(file)
    table.to_a[1..]
  end
end