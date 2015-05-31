class Address < ActiveRecord::Base
	belongs_to :wallet
	validates_presence_of :val
end
