require "rails_helper"

RSpec.describe CsvContractImportService do
  describe '#call' do
    let(:file_path) { Rails.root.join('tmp', 'file.csv') }
    let(:csv_data) do
      <<~CSV
        External Contract ID,Contract Name,Start Date,End Date,Contract Value,Supplier,Contract Owner
        1,Contract A,01/01/2023,12/31/2023,1000,Supplier A,owner1@example.com
        2,Contract B,02/01/2023,01/31/2024,2000,Supplier B,owner2@example.com
      CSV
    end

    before do
      File.write(file_path, csv_data)
    end

    after do
      File.delete(file_path)
    end

    it 'imports contracts and creates owners' do
      service = described_class.new(file_path)

      expect { service.call }.to change(Contract, :count).by(2)
                              .and change(ContractOwner, :count).by(2)

      expect(service.updated_contracts_counter).to eq(2)
      expect(service.invalid_contract_instances).to be_empty
      expect(service.result_batches.length).to eq(1)
    end
  end
end