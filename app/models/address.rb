class Address < ActiveRecord::Base
	belongs_to :wallet
	validates_presence_of :val
  has_many :outputs

  def get_confirmed_total
    # Find all unspent outputs
    outputs = Address.joins(outputs: :owner_transaction).where("addresses.id = ? AND transactions.confirmed = 1 AND outputs.as_transaction_input_id is NULL", self.id).sum("value")
  end

  def get_unconfirmed_total
    # Find all unspent outputs
    outputs = Address.joins(outputs: :owner_transaction).where("addresses.id = ? AND transactions.confirmed != 1 and outputs.as_transaction_input_id is NULL", self.id).sum("value")
  end

  def to_s
    self.val
  end
end
