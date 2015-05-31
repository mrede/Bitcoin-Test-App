class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :unique_key
      t.decimal :value
      t.binary :raw
      t.integer :address_id

      t.timestamps null: false
    end
  end
end
