require 'rails_helper'


RSpec.describe Wallet, type: :model do
  
  it { should validate_presence_of(:private_key) }
  it { should validate_presence_of(:public_key) }
  it { should validate_presence_of(:name) }

  it { should validate_uniqueness_of(:name) }

  it { should have_many(:addresses)}

  it "returns the string name" do
    wallet = create(:wallet)
    expect(wallet.to_s).to eq(wallet.name)
  end

  describe "#bitcoin_key" do
    it "returns a Bitcoin Key" do
      test_key = Bitcoin::generate_key
      wallet = create(:wallet, private_key: test_key[0], public_key: test_key[1])

      recreated_key = wallet.bitcoin_key
      expect(recreated_key.priv).to eq(test_key[0])
    end
  end
end
