require 'rails_helper'

RSpec.describe Wallet, type: :model do
  
  it { should validate_presence_of(:private_key) }
  it { should validate_presence_of(:public_key) }
  it { should validate_presence_of(:name) }
end
