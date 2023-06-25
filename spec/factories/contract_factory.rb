FactoryBot.define do
  factory :contract do
    name { Faker::Company.name }
    start_date { 6.months.ago }
    end_date { 6.months.from_now }
    value_cents { Faker::Number.between(from: 0, to: 100000) }
    external_contract_id { SecureRandom.uuid }
    association :contract_owner
  end
end
