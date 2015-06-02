require 'rails_helper'
require 'listener/transaction_listener'

RSpec.describe TransactionListener, type: :class do

	describe "#on_tx" do
    before(:each) do
      
    end
		context "when transaction is empty" do 
			it "Should exit gracefully" do 
        EM.run do
          test = TransactionListener.connect('104.131.149.35', 18333, [])
          expect {
            result = test.on_tx(nil)
            expect(result).to equal(false)
          }.to change(Transaction, :count).by(0) 

          

          EM.stop_event_loop
        end
      end
		end

    context "when transaction is in dataset" do 
      it "should update transaction with outputs" do
        EM.run do
          test = TransactionListener.connect('104.131.149.35', 18333, [])

          trans = create(:transaction)
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
	end



end