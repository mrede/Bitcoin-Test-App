require 'rails_helper'

RSpec.describe Transaction, type: :model do
  
  it { should validate_presence_of(:original_json) }
  
  it { should validate_presence_of(:unique_hash) }

  it { should have_many(:outputs)}

  it { should validate_uniqueness_of(:unique_hash)}

  describe "#create_from_tx" do
    context "when data is valid" do
      it "should create a new transction" do
        expect {

          tx = double("tx")
          allow(tx).to receive(:hash).and_return("1234567890")

          
          t= Transaction.create_from_tx(tx)

          }.to change(Transaction, :count).by(1)
      end
    end
    context "when data is invalid"
  end
end
