class CreateOutputs < ActiveRecord::Migration
  def change
    create_table :outputs do |t|
      t.integer :transaction_id
      t.integer :address_id
      t.integer :value
      

      t.timestamps null: false
    end
  end
end
