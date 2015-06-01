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

  describe "#find_for_amount" do
    it "should return the lowest output larger than amount" do
      output_1 = create(:unspent_output, value: 10000)
      output_2 = create(:unspent_output, value: 20000, address: output_1.address)
      output_3 = create(:unspent_output, value: 30000, address: output_1.address)

      amount = 15000

      outputs = Output.find_for_amount(amount, output_1.address.wallet)

      expect(outputs.length).to equal(1)
      expect(outputs[0].value).to equal(20000)
    end
    it "should return two outputs when amount larger than largest single amount" do
      output_1 = create(:unspent_output, value: 10000)
      output_2 = create(:unspent_output, value: 20000, address: output_1.address)
      output_3 = create(:unspent_output, value: 30000, address: output_1.address)

      amount = 35000 # Amount larger than single output

      outputs = Output.find_for_amount(amount, output_1.address.wallet)

      expect(outputs.length).to equal(2)
      expect(outputs[0].value).to equal(30000)
      expect(outputs[1].value).to equal(20000)
    end
    it "should return false if amount is greater than total wallet amount" do
      output_1 = create(:unspent_output, value: 10000)
      output_2 = create(:unspent_output, value: 20000, address: output_1.address)

      amount = 35000 # Amount larger than all outputs

      outputs = Output.find_for_amount(amount, output_1.address.wallet)

      expect(outputs).to equal(false)
    end

    it "should return the lowest output larger than amount and ignore spent values" do
      output_1 = create(:unspent_output, value: 10000)
      output_2 = create(:output, value: 20000, address: output_1.address)
      output_3 = create(:unspent_output, value: 30000, address: output_1.address)

      amount = 15000

      outputs = Output.find_for_amount(amount, output_1.address.wallet)

      expect(outputs.length).to equal(1)
      expect(outputs[0].value).to equal(30000) #20000 has been spent
    end
  end

  describe "#calculate_change" do
    it "should return the correct change amount" do
      outputs = []
      address = create(:address)
      outputs << create(:unspent_output, value: 10000, address: address)
      outputs << create(:unspent_output, value: 20000, address: address)
      outputs <<  create(:unspent_output, value: 30000, address: address)

      amount = 35000 # Amount larger than single output

      change = Output.calculate_change(outputs, amount)

      expect(change).to equal(25000)
    end
    it "returns if inputs are empty" do 
      change = Output.calculate_change([], 3500)

      expect(change).to equal(-3500)
      
    end
  end

  it "#to_s returns the value" do
    output = create(:output)
    expect(output.to_s).to eq(output.value)
  end
end
