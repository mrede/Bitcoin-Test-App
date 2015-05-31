require 'rails_helper'

RSpec.describe Address, type: :model do
  it { should belong_to(:wallet) }
  it { should validate_presence_of(:val) }
end
