require 'rails_helper'

RSpec.describe Address, type: :model do
  it { should belong_to(:wallet) }
  it { should validate_presence_of(:val) }

  describe "#check_outputs" do
  	context "When outputs are emtpy" do
  		it "should return false" do
  			expect(Address.match_outputs_to_address(nil)).to equal(false)
  		end
  	end
  	context "When outputs contain a destination address that we own" do
  		it "should create a new transaction" do

        # Create wallet
        wallet = create(:wallet_with_address)

        # Create some Mock TXOuts. # This can be greatly improved late
        script = double("script")
        allow(script).to receive(:get_addresses).and_return(wallet.addresses[0].val)
        output = double("txout")
        allow(output).to receive(:parsed_script).and_return(script)
        
        res = Address.match_outputs_to_address([output])
  			expect(res.id).to equal(wallet.addresses[0].id)
  		end
  	end
    context "When outputs doesnt belong to us" do
      it "should return false" do

        # Create wallet
        wallet = create(:wallet_with_address)

        # Create some Mock TXOuts. # This can be greatly improved late
        script = double("script")
        allow(script).to receive(:get_addresses).and_return("NOT MY ADDRESS")
        output = double("txout")
        allow(output).to receive(:parsed_script).and_return(script)
        
        res = Address.match_outputs_to_address([output])
        expect(res).to equal(false)
      end
    end

    context "When output addresses returns an array" do 
      it "should handle gracefully" do
        # Create wallet
        wallet = create(:wallet_with_address)
        
        # Create some Mock TXOuts. # This can be greatly improved late
        script = double("script")
        allow(script).to receive(:get_addresses).and_return(["ASDSDASDASDASD", "DSDSDSDS"])
        output = double("txout")
        allow(output).to receive(:parsed_script).and_return(script)

        res = Address.match_outputs_to_address([output])
        expect(res).to equal(false)
      end
    end
  end
end
