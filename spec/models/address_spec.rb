require 'rails_helper'

RSpec.describe Address, type: :model do
  it { should belong_to(:wallet) }
  it { should validate_presence_of(:val) }

  it "returns the string name" do
    address = create(:address)
    expect(address.to_s).to eq(address.val)
  end

  it { should have_many(:outputs)}

  describe "#get_confirmed_total" do
    it "should return the total of confirmed inputs" do
      address = create(:address)
      trans = create(:transaction, confirmed: 1)
      unconfirmed_trans = create(:transaction, confirmed: 0)
      output_1 = create(:unspent_output, value: 20000, address: address, owner_transaction: trans)
      output_2 = create(:unspent_output, value: 30000, address: address, owner_transaction: trans)
      output_2 = create(:unspent_output, value: 30000, address: address, owner_transaction: unconfirmed_trans)

      unspent = address.get_confirmed_total()
      expect(unspent).to equal(50000)
    end
    it "should not include spent inputs" do

      address = create(:address)
      output_1 = create(:output, value: 20000, address: address)
      output_2 = create(:unspent_output, value: 30000, address: address)

      unspent = address.get_confirmed_total()
      expect(unspent).to equal(30000)
    end
    it "should not include other address records" do
      address = create(:address)
      output_1 = create(:unspent_output, value: 20000, address: address)

      address2 = create(:address)
      output_2 = create(:unspent_output, value: 50000, address: address2)

      unspent = address.get_confirmed_total()
      expect(unspent).to equal(20000)
    end
  end

  describe "#get_unconfirmed_total" do
    it "should return the total of unconfirmed inputs" do
      address = create(:address)
      trans = create(:transaction, confirmed: 0)
      output_1 = create(:unspent_output, value: 20000, address: address, owner_transaction: trans)
      output_2 = create(:unspent_output, value: 30000, address: address, owner_transaction: trans)

      unspent = address.get_unconfirmed_total()
      expect(unspent).to equal(50000)
    end
    it "should not include spent inputs" do

      address = create(:address)
      trans = create(:transaction, confirmed: 0)
      confirmed_trans = create(:transaction, confirmed: 1)
      output_1 = create(:unspent_output, value: 20000, address: address, owner_transaction: trans)
      output_2 = create(:unspent_output, value: 30000, address: address, owner_transaction: confirmed_trans)

      unspent = address.get_unconfirmed_total()
      expect(unspent).to equal(20000)
    end
    it "should not include other address records" do
      address = create(:address)
      trans = create(:transaction, confirmed: 1)
      output_1 = create(:unspent_output, value: 20000, address: address, owner_transaction: trans)

      address2 = create(:address)
      trans_2 = create(:transaction, confirmed: 1)
      output_2 = create(:unspent_output, value: 50000, address: address2, owner_transaction: trans_2)

      unspent = address.get_confirmed_total()
      expect(unspent).to equal(20000)
    end
  end

end
