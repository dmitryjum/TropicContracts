class CsvContractImportJob < ApplicationJob
  # include Sidekiq::Job
  queue_as :csv_import

  def perform(csv_array, session_id)
    import_service = CsvContractImportService.new(csv_array, session_id)
    import_service.call
  end
end
