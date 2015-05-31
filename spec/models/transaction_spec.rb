require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should belong_to(:address) }
  it { should validate_presence_of(:raw) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:unique_key) }
end
