class Transaction < ActiveRecord::Base

  validates_presence_of :unique_hash, :original_json
  validates_uniqueness_of :unique_hash
  has_many :outputs
  has_many :inputs, class_name: "Output", foreign_key: "as_transaction_input_id"

  def self.create_from_tx(inputs, new_tx)
    return false unless !new_tx.nil?
    trans = Transaction.new
    trans.inputs << inputs
    trans.original_json = new_tx.to_json
    trans.unique_hash = new_tx.hash
    # We don't need to record outputs as they will appear from server
    trans.save

  end
end
