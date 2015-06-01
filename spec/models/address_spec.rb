require 'rails_helper'

RSpec.describe Address, type: :model do
  it { should belong_to(:wallet) }
  it { should validate_presence_of(:val) }

  it "returns the string name" do
    address = create(:address)
    expect(address.to_s).to eq(address.val)
  end

  it { should have_many(:outputs)}

end
