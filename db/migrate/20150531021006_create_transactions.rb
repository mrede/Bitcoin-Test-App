class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :unique_hash
      
      t.text :original_json
      

      t.timestamps null: false
    end
  end
end
