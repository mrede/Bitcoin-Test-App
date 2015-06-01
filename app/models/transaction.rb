class Transaction < ActiveRecord::Base

  validates_presence_of :unique_hash, :original_json
  validates_uniqueness_of :unique_hash
  has_many :outputs



  def self.create_from_tx(tx)
    t = Transaction.new
    t.unique_hash = tx.hash
    t.original_json = "BLAH"
    res = t.save

    puts "TRAN #{t.id} = #{res} #{t.errors.to_hash}"

  end
end
