class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.int :wallet_id
      t.string :val

      t.timestamps null: false
    end
  end
end
