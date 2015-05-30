class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.string :private_key
      t.string :public_key
      t.string :name

      t.timestamps null: false
    end
  end
end
