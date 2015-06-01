class Output < ActiveRecord::Base
  belongs_to :owner_transaction, foreign_key: "transaction_id", class_name: "Transaction"
  belongs_to :address
end
