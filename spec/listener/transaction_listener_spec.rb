require 'rails_helper'
require 'listener/transaction_listener'
include Bitcoin

RSpec.describe TransactionListener, type: :class do

	describe "#on_tx" do
    before(:each) do
      
    end
		context "when transaction is empty" do 
			it "Should exit gracefully" do 
        sleep 1.seconds
        EM.run do
          test = TransactionListener.connect('127.0.0.1', 8332, [])
          expect {
            result = test.on_tx(nil)
            expect(result).to equal(false)
          }.to change(Transaction, :count).by(0) 

          

          EM.stop_event_loop
        end
      end
		end

    context "when transaction is in dataset" do 
      context "when stored transaction already has outputs" do
        it "should update transaction with outputs" do
          sleep 1.seconds
          EM.run do
            sleep 1.seconds
            address = create(:address, val: "mpefodNfRXAnB4ot5BVPfbZudjAe7nUrc7")
            output = create(:unspent_output, value: 1000000, address: address)
            trans = create(:transaction)
            trans.outputs << output
            trans.save
            
            test = TransactionListener.connect('127.0.0.1', 8332, [])

            
            tx = Bitcoin::P::Tx.from_json(trans.original_json)
            trans.unique_hash = tx.hash
            trans.save

            expect {
              result = test.on_tx(tx)
              expect(result).to equal(false)
            }.to change(Transaction, :count).by(0)

            

            EM.stop_event_loop
          end
        end
      end
      context "when stored trans doesn't have outputs" do
        it "should update transaction with outputs" do
          sleep 1.seconds
          EM.run do
            sleep 1.seconds
            address = create(:address, val: "mpefodNfRXAnB4ot5BVPfbZudjAe7nUrc7")
            
            trans = create(:transaction)
            
            
            test = TransactionListener.connect('127.0.0.1', 8332, [])

            
            tx = Bitcoin::P::Tx.from_json(trans.original_json)
            trans.unique_hash = tx.hash
            trans.save

            expect {
              result = test.on_tx(tx)
              expect(result).to equal(true)
            }.to change(Transaction, :count).by(0)

            

            EM.stop_event_loop
          end
        end
      end

    end
	end

  describe "#on_block" do
    context "Block invalid" do
      it "returns false" do
        sleep 1.seconds
        EM.run do
          sleep 1.seconds
          test = TransactionListener.connect('127.0.0.1', 8332, [])

          result = test.on_block(nil)
          expect(result).to equal(false)
          
          EM.stop_event_loop
        end
      end
    end
    context "Block exists" do
      

      it "marks unconfirmed transaction" do
        wallet = create(:wallet)
        address = create(:address, wallet: wallet)
        trans = create(:transaction, confirmed: 0)

        dummy_trans = instance_double("Tx", hash: trans.unique_hash)

        # Create dummy block
        block = instance_double("Block", :tx => [
          {hash: "12345"},
          dummy_trans
          ],
          :bip34_block_height => 12345
        )

        sleep 1.seconds
        EM.run do
          sleep 1.seconds
          test = TransactionListener.connect('127.0.0.1', 8332, [])

          result = test.on_block(block)

          trans.reload

          expect(trans.confirmed).to equal(1)
          EM.stop_event_loop
        end
      end
      it "marks unconfirmed transaction 2" do
        wallet = create(:wallet)
        address = create(:address, wallet: wallet)
        trans = create(:transaction, confirmed: nil)

        dummy_trans = instance_double("Tx", hash: trans.unique_hash)

        # Create dummy block
        block = instance_double("Block", :tx => [
          {hash: "12345"},
          dummy_trans
          ],
          :bip34_block_height => 12345
        )

        sleep 1.seconds
        EM.run do
          sleep 1.seconds
          test = TransactionListener.connect('127.0.0.1', 8332, [])

          result = test.on_block(block)

          trans.reload

          expect(trans.confirmed).to equal(1)
          EM.stop_event_loop
        end
      end
    end
  end



end