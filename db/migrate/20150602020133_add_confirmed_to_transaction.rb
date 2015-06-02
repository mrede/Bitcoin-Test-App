class AddConfirmedToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :confirmed, :integer
  end
end
