require "rails_helper"

RSpec.describe Contract, type: :model do
  describe "validations" do
    it { should validate_presence_of(:external_contract_id) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:value_cents) }
    it { should validate_presence_of(:external_contract_id) }
    it { should validate_numericality_of(:value_cents).is_greater_than(0) }

    it "validates uniqueness of `external_contract_id`" do
      FactoryBot.create(:contract)
      should validate_uniqueness_of(:external_contract_id)
    end

    it "validates `end_date` is after `start_date`" do
      contract = FactoryBot.build(:contract, start_date: Date.today, end_date: 3.days.ago)
      expect(contract).to be_invalid
      expect(contract.errors.size).to eql(1)
      expect(contract.errors.full_messages.first).to include("End date must be greater than")
    end
  end

  describe "associations" do
    it { should belong_to(:contract_owner) }
  end

  describe 'scopes' do
    describe '.by_supplier' do
      let!(:contract1) { FactoryBot.create(:contract, supplier: 'Supplier A') }
      let!(:contract2) { FactoryBot.create(:contract, supplier: 'Supplier B') }
      let!(:contract3) { FactoryBot.create(:contract, supplier: 'Supplier C') }

      it 'returns contracts matching the given supplier' do
        expect(Contract.by_supplier('Supplier A')).to eq([contract1])
        expect(Contract.by_supplier('Supplier B')).to eq([contract2])
        expect(Contract.by_supplier('Supplier C')).to eq([contract3])
      end

      it 'does not return contracts with different suppliers' do
        expect(Contract.by_supplier('Supplier A')).not_to include(contract2, contract3)
        expect(Contract.by_supplier('Supplier B')).not_to include(contract1, contract3)
        expect(Contract.by_supplier('Supplier C')).not_to include(contract1, contract2)
      end
    end
  end

  describe 'class methods' do
    describe '.avg_value_per_supplier' do
      let!(:contract1) { FactoryBot.create(:contract, supplier: 'Supplier A', value_cents: 1000) }
      let!(:contract2) { FactoryBot.create(:contract, supplier: 'Supplier A', value_cents: 2000) }
      let!(:contract3) { FactoryBot.create(:contract, supplier: 'Supplier A', value_cents: 3000) }

      it 'returns the average value per supplier' do
        expect(Contract.avg_value_per_supplier(supplier: 'Supplier A')).to eq('$20.00') # Assuming your Money format is '$X.XX'
      end
    end
  end
end
