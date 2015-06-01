module Bitcoin
  module  TxExtensions
     
    def create_transaction(outputs)
      return false unless !outputs.nil?

      # Return aray of transactions
      trans = Transaction.new

      # store hash

      outputs.each do |out|
        addresses = out.parsed_script.get_addresses

        # Make sure we have an array
        if addresses.kind_of?(String)
          addresses = [addresses]
        end
        addresses.each  do |addr|
          address = Address.where("val=?", addr).first

          puts "VALUE #{out.amount} : Address: #{addr} : #{address}"
          unless address.nil?
            our_output = Output.new
            our_output.value = out.amount
            our_output.address = address
            trans.outputs << our_output
          end
        end

      end
      
      if trans.outputs.length ==0
        puts "Returning no outputs"
        return false
      end
      puts "Output length #{trans.outputs.length}"
      return trans
        
    end

  end

  class Bitcoin::Protocol::Tx
    include TxExtensions
  end

end