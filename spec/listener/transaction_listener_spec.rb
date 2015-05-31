require 'rails_helper'
require 'listener/transaction_listener'

RSpec.describe TransactionListener, type: :class do

	describe "#on_tx" do
		context "when transaction is empty" do 
			it "Should exit gracefully" do 
        EM.run do
          test = TransactionListener.connect_random_from_dns([])
          result = test.on_tx(nil)

          expect(result).to equal(false)

          EM.stop_event_loop
        end
      end
		end
	end



end