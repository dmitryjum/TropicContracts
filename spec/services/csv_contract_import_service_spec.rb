require "rails_helper"

RSpec.describe CsvContractImportService do
  describe '#call' do
    let(:file_path) { Rails.root.join('tmp', 'file.csv') }
    let(:invalid_records_file_path) { Rails.root.join('tmp', 'invalid_records_file.csv') }
    let(:csv_data) do
      <<~CSV
        External Contract ID,Contract Name,Start Date,End Date,Contract Value,Supplier,Contract Owner
        1,Contract A,01/01/2023,12/31/2023,1000,Supplier A,owner1@example.com
        2,Contract B,02/01/2023,01/31/2024,2000,Supplier B,owner2@example.com
      CSV
    end
    let(:invalid_rows_csv_data) do
      <<~CSV
        External Contract ID,Contract Name,Start Date,End Date,Contract Value,Supplier,Contract Owner
        1,Contract A,01/01/2023,12/31/2023,1000,Supplier A,owner1@example.com
        2,Contract B,02/01/2023,,2000,Supplier B,owner2@example.com
        3,,03/01/2023,03/31/2023,3000,Supplier C,owner3@example.com
      CSV
    end

    it 'imports contracts and creates owners' do
      File.write(file_path, csv_data)
      service = described_class.new(file_path)

      expect { service.call }.to change(Contract, :count).by(2)
                              .and change(ContractOwner, :count).by(2)

      expect(service.updated_contracts_counter).to eq(2)
      expect(service.invalid_contract_instances).to be_empty
      expect(service.result_batches.length).to eq(1)
      File.delete(file_path)
    end

    it 'imports contracts and handles invalid instances' do
      File.write(invalid_records_file_path, invalid_rows_csv_data)
      service = described_class.new(invalid_records_file_path)

      expect { service.call }.to change(Contract, :count).by(1)
                              .and change(ContractOwner, :count).by(3)

      expect(service.updated_contracts_counter).to eq(1)
      expect(service.invalid_contract_instances.length).to eq(2)
      expect(service.result_batches.length).to eq(1)

      invalid_contract1 = service.invalid_contract_instances[0]
      expect(invalid_contract1.external_contract_id).to eq('2')
      expect(invalid_contract1.name).to eq('Contract B')
      expect(invalid_contract1.start_date).to eq(Date.strptime('02/01/2023', '%m/%d/%Y'))
      expect(invalid_contract1.end_date).to be_nil
      expect(invalid_contract1.value_cents).to eq(2000)
      expect(invalid_contract1.supplier).to eq('Supplier B')
      expect(invalid_contract1.contract_owner_id).not_to be_nil

      invalid_contract2 = service.invalid_contract_instances[1]
      expect(invalid_contract2.external_contract_id).to eq('3')
      expect(invalid_contract2.name).to be_nil
      expect(invalid_contract2.start_date).to eq(Date.strptime('03/01/2023', '%m/%d/%Y'))
      expect(invalid_contract2.end_date).to eq(Date.strptime('03/31/2023', '%m/%d/%Y'))
      expect(invalid_contract2.value_cents).to eq(3000)
      expect(invalid_contract2.supplier).to eq('Supplier C')
      expect(invalid_contract2.contract_owner_id).not_to be_nil
      File.delete(invalid_records_file_path)
    end
  end
end