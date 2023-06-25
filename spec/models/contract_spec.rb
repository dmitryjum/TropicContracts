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
end
