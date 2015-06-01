require 'rails_helper'

RSpec.describe Transaction, type: :model do
  
  it { should validate_presence_of(:original_json) }
  
  it { should validate_presence_of(:unique_hash) }

  it { should have_many(:outputs)}
  it { should have_many(:inputs)}

  it { should validate_uniqueness_of(:unique_hash)}

  
end
