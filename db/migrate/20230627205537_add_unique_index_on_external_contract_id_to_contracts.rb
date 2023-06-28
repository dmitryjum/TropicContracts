class AddUniqueIndexOnExternalContractIdToContracts < ActiveRecord::Migration[7.0]
  def change
    remove_index :contracts, :external_contract_id
    add_index :contracts, :external_contract_id, unique: true
  end
end
