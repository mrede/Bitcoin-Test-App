require 'rails_helper'

RSpec.describe Output, type: :model do
  it { should belong_to(:owner_transaction) }
  it { should belong_to(:as_transaction_input) }
  it { should belong_to(:address) }

  describe "#amount_mbtc" do
    it "should display value in mBTC" do
      output = create(:output, value: 100000000)
      expect(output.value_mbtc).to eq(1000)
    end
    it "should handle zero value" do
      output = create(:output, value: 0)
      expect(output.value_mbtc).to eq(0)
    end
  end
end
