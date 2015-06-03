class Wallet < ActiveRecord::Base
	validates_presence_of :private_key, :public_key, :name

	validates_uniqueness_of :name

  has_many :addresses

  def self.build_secure_wallet(params)
    wallet = Wallet.new(params)

    key = Bitcoin::generate_key
    wallet.private_key = key[0]
    wallet.public_key = key[1]
    wallet
  end

  def bitcoin_key
    key = Bitcoin::Key.new(self.private_key, self.public_key)
  end

  def to_s
    self.name
  end
end
