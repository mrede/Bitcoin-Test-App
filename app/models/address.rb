class Address < ActiveRecord::Base
	belongs_to :wallet
	validates_presence_of :val

  # Checks Address db for any matching output addresses
	def self.check_outputs(outputs)
		return false unless !outputs.nil?

    	outputs.each do |out|

      address = Address.where("val=?", out.parsed_script.get_addresses).first
      puts "ADDRESSES #{out.parsed_script.get_addresses}, address: #{address}"
      unless address.nil?
        puts "We've found address #{address.val}"
        # Create transaction 
        t = Transaction.new

      end
      
    end
	end
end
