require 'rails_helper'

RSpec.describe Transaction, type: :model do
  
  it { should validate_presence_of(:original_json) }
  
  it { should validate_presence_of(:unique_hash) }

  it { should have_many(:outputs)}
  it { should have_many(:inputs)}

  it { should validate_uniqueness_of(:unique_hash)}

  describe "#create_from_tx" do
    before(:each) do
      @trans = create(:transaction)
      @tx = Bitcoin::P::Tx.from_json(@trans.original_json)
      @output = create(:output, owner_transaction: @trans)
      @inputs = [@output]
    end

    it "handles empty tx" do

      res = Transaction.create_from_tx(@inputs, nil)
      expect(res).to equal(false)

    end
    it "handles empty inputs" do
      expect {
        Transaction.create_from_tx([], @tx)
      }.to change(Transaction, :count).by(1)
    end
    it "creates transaction if inputs and tx is ok" do
      expect {
        Transaction.create_from_tx(@inputs, @tx)
      }.to change(Transaction, :count).by(1)
    end
  end
end
