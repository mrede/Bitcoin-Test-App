class Transaction < ActiveRecord::Base

  validates_presence_of :unique_key, :value, :raw
  belongs_to :address


  def self.create_from_tx(tx, address)
    t = Transaction.new
    t.unique_key = tx.hash
    t.address = address
    t.value = 123
    t.raw = 123
    res = t.save

    puts "TRAN #{t.id} = #{res} #{t.errors.to_hash}"

  end
end
