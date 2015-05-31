class Address < ActiveRecord::Base
	belongs_to :wallet
	validates_presence_of :val

  # Checks Address db for any matching output addresses
	def self.match_outputs_to_address(outputs)
		return false unless !outputs.nil?

    	outputs.each do |out|
      address = Address.where("val=?", out.parsed_script.get_addresses).first
      
      unless address.nil?
        
        return address

      end
      
    end
	end
end
