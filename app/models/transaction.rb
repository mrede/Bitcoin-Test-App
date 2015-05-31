class Transaction < ActiveRecord::Base

  validates_presence_of :unique_key, :value, :raw
  belongs_to :address
end
