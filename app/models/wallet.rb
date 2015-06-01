class Wallet < ActiveRecord::Base
	validates_presence_of :private_key, :public_key, :name

	validates_uniqueness_of :name

  has_many :addresses

  def to_s
    self.name
  end
end
