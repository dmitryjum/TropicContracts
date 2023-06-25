class DeleteUsers < ActiveRecord::Migration[7.0]
  def change
    remove_reference(:contracts, :user)
    drop_table(:users)
  end
end
