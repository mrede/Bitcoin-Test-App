class AddInputTransactionToOutput < ActiveRecord::Migration
  def change
    add_column :outputs, :as_transaction_input_id, :integer
  end
end
