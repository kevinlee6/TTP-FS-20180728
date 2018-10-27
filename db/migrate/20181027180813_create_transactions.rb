class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :ticker, null: false
      t.integer :qty, null: false
      t.float :price_per_share, null: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
