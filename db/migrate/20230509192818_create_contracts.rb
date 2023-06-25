class CreateContracts < ActiveRecord::Migration[7.0]
  def change
    create_table :contracts do |t|
      t.string :external_contract_id, null: false, unique: true, index: true
      t.string :name, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :value_cents, null: false

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
