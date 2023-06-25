# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
bob = ContractOwner.find_or_initialize_by(first_name: "Bob", last_name: "Smith", email: "bob.smith@example.com")
john = ContractOwner.find_or_initialize_by(first_name: "John", last_name: "Doe", email: "john.doe@example.com")

Contract.find_or_create_by!(
  external_contract_id: "488c9387-9563-48ea-8b20-42f32c78cf8e",
  name: "Company Messenger",
  start_date: "2023-01-01",
  end_date: "2023-03-31",
  value_cents: 10_000_00,
  contract_owner: bob
)
Contract.find_or_create_by!(
  external_contract_id: "77ee1b77-a10e-40f7-bf60-a90ec49975a7",
  name: "Company Messenger",
  start_date: "2023-04-01",
  end_date: "2023-07-31",
  value_cents: 10_000_00,
  contract_owner: bob
)
Contract.find_or_create_by!(
  external_contract_id: "e5bb5c98-61cd-4bd5-8d9e-2a67eb8945fb",
  name: "something important",
  start_date: "2023-01-01",
  end_date: "2023-12-31",
  value_cents: 500_000_00,
  contract_owner: bob
)
Contract.find_or_create_by!(
  external_contract_id: "9e253491-7610-4e07-a51f-78b18d0452de",
  name: "Company Messenger",
  start_date: "2022-01-01",
  end_date: "2022-03-31",
  value_cents: 10_000_00,
  contract_owner: john
)
Contract.find_or_create_by!(
  external_contract_id: "69a6924c-23d7-4b1b-8800-13661095cd06",
  name: "Application Software",
  start_date: "2022-01-01",
  end_date: "2022-03-31",
  value_cents: 10_000_00,
  contract_owner: john
)
