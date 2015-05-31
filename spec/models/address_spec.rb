require 'rails_helper'

RSpec.describe Address, type: :model do
  it { should belong_to(:wallet) }
  it { should validate_presence_of(:val) }

  describe "#check_outputs" do
  	context "When outputs are emtpy" do
  		it "should return false" do
  			expect(Address.check_outputs(nil)).to equal(false)
  		end
  	end
  	context "When outputs contain a destination address that we own" do
  		it "should create a new transaction" do
  			expect {

          }.to change(Transaction, :count).by(1)
  		end
  	end
  end
end
