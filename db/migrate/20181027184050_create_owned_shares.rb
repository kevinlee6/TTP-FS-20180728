class CreateOwnedShares < ActiveRecord::Migration[5.2]
  def change
    create_table :owned_shares do |t|
      t.belongs_to :user
      t.string :ticker, null: false
      t.integer :num_shares, null: false

      t.timestamps
    end
  end
end
