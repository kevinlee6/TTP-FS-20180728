class AddBalanceToPortfolio < ActiveRecord::Migration[5.2]
  def change
    add_column :portfolios, :balance, :float, default: 5000
  end
end
