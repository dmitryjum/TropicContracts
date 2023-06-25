class AddContractOwnersToContracts < ActiveRecord::Migration[7.0]
  def change
    add_reference(:contracts, :contract_owner, index: true, foreign_key: true)
  end
end
