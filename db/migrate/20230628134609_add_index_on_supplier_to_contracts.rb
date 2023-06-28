class AddIndexOnSupplierToContracts < ActiveRecord::Migration[7.0]
  def change
    add_index :contracts, "to_tsvector('english', supplier)", using: :gin
  end
end
