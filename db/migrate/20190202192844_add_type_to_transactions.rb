class AddTypeToTransactions < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
     CREATE TYPE transaction_type AS ENUM ('buy', 'sell');

     ALTER TABLE transactions
     ADD type transaction_type;

     UPDATE transactions SET type='buy';

     ALTER TABLE transactions
     ALTER COLUMN type SET NOT NULL;

     CREATE INDEX transaction_type_index ON transactions(type);
    SQL
  end

  def down
    # index autoremove after remove_column in Rails 4 and up
    remove_column :transactions, :type
    execute <<-SQL
      DROP TYPE transaction_type;
    SQL
  end
end
