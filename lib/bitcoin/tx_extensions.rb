module Bitcoin
  module  TxExtensions
     
    def create_transaction(outputs)
      return false unless !outputs.nil?

      # Return aray of transactions
      trans = Transaction.where(:unique_hash => self.hash).first
      if trans.nil?
        # Trans is nul
        trans = Transaction.new
      end
      if trans.outputs.length > 0
        return false
      end

      # store hash

      outputs.each do |out|
        addresses = out.parsed_script.get_addresses

        # Make sure we have an array
        if addresses.kind_of?(String)
          addresses = [addresses]
        end
        addresses.each  do |addr|
          address = Address.where("val=?", addr).first

          unless address.nil?
            our_output = Output.new
            our_output.value = out.amount
            our_output.address = address
            trans.outputs << our_output
          end
        end

      end
      
      if trans.outputs.length ==0
        return false
      end

      return trans
        
    end

  end

  class Bitcoin::Protocol::Tx
    include TxExtensions
  end

end