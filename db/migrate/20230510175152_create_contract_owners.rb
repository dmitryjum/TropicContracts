class CreateContractOwners < ActiveRecord::Migration[7.0]
  def change
    create_table :contract_owners do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false, default: ""

      t.timestamps null: false
    end

    add_index :contract_owners, :email, unique: true
  end
end
