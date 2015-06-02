require 'rails_helper'

# Not loading lib path properle
require 'bitcoin/tx_extensions'

require 'pp'

#require 'listener/transaction_listener'

RSpec.describe Bitcoin::TxExtensions, type: :module do

  describe "#create_transaction" do

    let(:dummy_tx) { Class.new { include Bitcoin::TxExtensions 
        def hash
            "TEST_TRANSACTION_HASH"
        end} 
    }

    context "When outputs are emtpy" do
      it "should return false" do
        tx = dummy_tx.new
        expect(tx.create_transaction(nil)).to equal(false)
      end
    end

    context "When outputs contain a destination address that we own" do
      it "should create a new transaction" do

        # Create wallet
        wallet = create(:wallet_with_address)

        # Create some Mock TXOuts. # This can be greatly improved later
        script = double("script")
        allow(script).to receive(:get_addresses).and_return(wallet.addresses[0].val)
        output = instance_double("TxOut", :amount => 123)
        allow(output).to receive(:parsed_script).and_return(script)
        
        tx = dummy_tx.new
        
        res = tx.create_transaction([output])
        expect(res.class).to equal(Transaction)
        expect(res.outputs.length).to equal(1)
    
      end

      it "should update existing transaction if it doesn't have outputs" do

        # Create wallet
        wallet = create(:wallet_with_address)
        trans = create(:transaction, unique_hash: "TEST_TRANSACTION_HASH")

        # Create some Mock TXOuts. # This can be greatly improved later
        script = double("script")
        allow(script).to receive(:get_addresses).and_return(wallet.addresses[0].val)
        output = instance_double("TxOut", :amount => 123)
        allow(output).to receive(:parsed_script).and_return(script)
        
        tx = dummy_tx.new
        
        res = tx.create_transaction([output])
        expect(res.class).to equal(Transaction)
        expect(res.outputs.length).to equal(1)
        expect(res.id).to equal(trans.id)
      end
    end



    context "When outputs doesnt belong to us" do
      it "should return false" do

        # Create wallet
        wallet = create(:wallet_with_address)

        # Create some Mock TXOuts. # This can be greatly improved late
        script = double("script")
        allow(script).to receive(:get_addresses).and_return("NOT MY ADDRESS")
        output = instance_double("TxOut", :amount => 123)
        allow(output).to receive(:parsed_script).and_return(script)

        tx = dummy_tx.new
        
        res = tx.create_transaction([output])
        expect(res).to equal(false)
      end
    end

    context "When output addresses returns an array" do 
      it "should handle gracefully" do
        # Create wallet
        wallet = create(:wallet_with_address)
        
        # Create some Mock TXOuts. # This can be greatly improved late
        script = double("script")
        allow(script).to receive(:get_addresses).and_return(["NOT MY ADDRESS", wallet.addresses[0].val])
        output = instance_double("TxOut", :amount => 123)
        allow(output).to receive(:parsed_script).and_return(script)

        tx = dummy_tx.new
        
        res = tx.create_transaction([output])
        expect(res.class).to equal(Transaction)
        expect(res.outputs.length).to equal(1)
      end
    end
  end

end