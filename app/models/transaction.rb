class Transaction < ActiveRecord::Base

  validates_presence_of :unique_hash, :original_json
  validates_uniqueness_of :unique_hash
  has_many :outputs

end
