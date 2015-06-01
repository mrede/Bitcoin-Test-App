require 'rails_helper'

RSpec.describe Output, type: :model do
  it { should belong_to(:owner_transaction) }
  it { should belong_to(:address) }
end
