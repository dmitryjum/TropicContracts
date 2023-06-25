class AddSupplierToContracts < ActiveRecord::Migration[7.0]
  def change
    add_column :contracts, :supplier, :string, index: true
  end
end
