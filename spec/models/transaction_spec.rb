require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should belong_to(:address) }
  it { should validate_presence_of(:raw) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:unique_key) }

  describe "#create_from_tx" do
    context "when data is valid" do
      it "should create a new transction" do
        expect {

          tx = double("tx")
          allow(tx).to receive(:hash).and_return("1234567890")

          address = create(:address)
          t= Transaction.create_from_tx(tx, address)

          }.to change(Transaction, :count).by(1)
      end
    end
    context "when data is invalid"
  end
end
