class CsvContractImportJob < ApplicationJob
  # include Sidekiq::Job
  queue_as :csv_import

  def perform(file_path, session_id)
    import_service = CsvContractImportService.new(file_path, session_id)
    import_service.call
  end
end
