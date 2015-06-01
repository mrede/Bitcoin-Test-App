class Output < ActiveRecord::Base
  belongs_to :owner_transaction, foreign_key: "transaction_id", class_name: "Transaction"
  belongs_to :as_transaction_input, foreign_key: "as_transaction_input_id", class_name: "Transaction"
  belongs_to :address

  def value_mbtc
    self.value / 100000
  end
end
