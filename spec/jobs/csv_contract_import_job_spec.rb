require 'rails_helper'

RSpec.describe CsvContractImportJob, type: :job do
  include ActiveJob::TestHelper

  let(:csv_array) do
    [
      ["John.Doe@example.com", "123", "Contract 1", "01/08/2023", "01/08/2024", "1000", "Supplier 1"],
      ["Jane.Doe@example.com", "456", "Contract 2", "02/08/2023", "02/08/2024", "2000", "Supplier 2"]
    ]
  end

  it "imports CSV contracts and enqueues the next job if more data is present" do
    # Use perform_enqueued_jobs to ensure job enqueuing is simulated
    perform_enqueued_jobs do
      sleep 1
      expect {
        CsvContractImportJob.perform_later(csv_array: csv_array, session_id: nil)
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)

      # Add assertions for the expected results or behavior
      # For example, you can check if contracts were created with the correct attributes:
      expect(Contract.pluck(:name)).to contain_exactly("Contract 1", "Contract 2")
      expect(Contract.pluck(:contract_owner_id)).to contain_exactly(
        ContractOwner.find_by(email: "John.Doe@example.com").id,
        ContractOwner.find_by(email: "Jane.Doe@example.com").id
      )
    end
  end
end