class AddTypeToTransactions < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
     CREATE TYPE transaction_method AS ENUM ('buy', 'sell');

     ALTER TABLE transactions
     ADD method transaction_method;

     UPDATE transactions SET method='buy';

     ALTER TABLE transactions
     ALTER COLUMN method SET NOT NULL;

     CREATE INDEX transaction_method_index ON transactions(method);
    SQL
  end

  def down
    # index autoremove after remove_column in Rails 4 and up
    remove_column :transactions, :method
    execute <<-SQL
      DROP TYPE transaction_method;
    SQL
  end
end
