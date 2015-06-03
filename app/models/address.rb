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
    outputs = Address.joins(outputs: :owner_transaction).where("addresses.id = ? AND (transactions.confirmed = 0 OR transactions.confirmed IS NULL) and outputs.as_transaction_input_id is NULL", self.id).sum("value")
  end

  def self.build_new_address(public_key)
    address = Address.new
    address.val = Bitcoin::pubkey_to_address(public_key)
    address
  end

  def to_s
    self.val
  end
end
