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

  describe "#get_confirmed_total" do
    before(:each) do
      @wallet = create(:wallet)
      @address = create(:address, wallet: @wallet)
      @output_1 = create(:unspent_output, value: 20000, address: @address)
      @output_2 = create(:unspent_output, value: 30000, address: @address)

      @wallet_2 = create(:wallet)
      @address_2 = create(:address, wallet: @wallet_2)
      @output_2_1 = create(:unspent_output, value: 60000, address: @address_2)
      @output_2_2 = create(:unspent_output, value: 70000, address: @address_2)

    end

    it "should total unspent amounts in all addresses" do
      unspent = @wallet.get_confirmed_total()
      expect(unspent).to equal(50000)
    end
    it "should not include addresses not belonging to wallet" do
      unspent = @wallet.get_confirmed_total()
      expect(unspent).to equal(50000)
    end

  end

  describe "#get_unconfirmed_total" do
    before(:each) do
      @wallet = create(:wallet)
      @address = create(:address, wallet: @wallet)

      @trans_1 = create(:transaction, confirmed: 0)
      @output_1 = create(:unspent_output, value: 20000, address: @address, owner_transaction: @trans_1)
      
      @trans_2 = create(:transaction, confirmed: 1)
      @output_2 = create(:unspent_output, value: 30000, address: @address, owner_transaction: @trans_2)

      @wallet_2 = create(:wallet)
      @address_2 = create(:address, wallet: @wallet_2)
      @output_2_1 = create(:unspent_output, value: 60000, address: @address_2)
      @output_2_2 = create(:unspent_output, value: 70000, address: @address_2)

    end

    it "should total unconfirmed unspent amounts in all addresses" do
      unspent = @wallet.get_unconfirmed_total()
      expect(unspent).to equal(20000)
    end
    it "should not include addresses not belonging to wallet" do
      unspent = @wallet.get_unconfirmed_total()
      expect(unspent).to equal(20000)
    end
  end
end
