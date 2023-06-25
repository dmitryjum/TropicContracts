require "rails_helper"

RSpec.describe "Contracts Index", type: :system do
  let!(:contract_1) { FactoryBot.create(:contract, name: "ABC 2023", value_cents: 50_000_00) }
  let!(:contract_2) { FactoryBot.create(:contract, name: "XYZ 2023", value_cents: 100_000_00) }

  it "lists all contracts" do
    visit contracts_path

    within "#contract_#{contract_1.id}" do
      expect(page).to have_content("ABC 2023")
      expect(page).to have_content("$50,000.00")
    end

    within "#contract_#{contract_2.id}" do
      expect(page).to have_content("XYZ 2023")
      expect(page).to have_content("$100,000.00")
    end
  end
end
