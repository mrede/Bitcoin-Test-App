class Address < ActiveRecord::Base
	belongs_to :wallet
	validates_presence_of :val

  # Checks Address db for any matching output addresses
	def self.match_outputs_to_address(outputs)
		return false unless !outputs.nil?

    	outputs.each do |out|
        addresses = out.parsed_script.get_addresses
        puts "ADddreses #{addresses}"

        if addresses.kind_of?(String)
          addresses = [addresses]
        end
        addresses.each  do |addr|
          address = Address.where("val=?", addr).first

          puts "VALUE #{out.amount}"
          unless address.nil?
            return address
          end

        end
      
      
      return false
      
    end
	end
end
