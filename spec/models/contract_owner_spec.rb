require "rails_helper"

RSpec.describe ContractOwner, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it "validates email format" do
      owner = FactoryBot.build(:contract_owner)
      owner.email = "owner@example.com"
      expect(owner).to be_valid

      owner.email = "owner"
      expect(owner).to be_invalid

      owner.email = "owner@example"
      expect(owner).to be_invalid
    end
  end
end
