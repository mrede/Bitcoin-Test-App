class Address < ActiveRecord::Base
	belongs_to :wallet
	validates_presence_of :val
  has_many :outputs

 

  def to_s
    self.val
  end
end
