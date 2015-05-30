require 'spec_helper'

class Wallet < ActiveRecord::Base
	validates_presence_of :private_key
end
