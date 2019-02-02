class AddTypeToTransactions < ActiveRecord::Migration[5.2]
  def change
    # Will be type enum; { BUY: 0, SELL: 1 }
    add_column :transactions, :type, :integer
    Transaction.update_all type: 0
    change_column :transactions, :type, :integer, null: false
  end
end
