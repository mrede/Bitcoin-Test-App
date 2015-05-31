FactoryGirl.define do
  factory :wallet do
    private_key "MyString"
    public_key "MyString"
    name { Faker::Name.first_name }
  

    factory :wallet_with_address do

      after(:build) do |wallet, evaluator|
        wallet.addresses << create(:address, wallet: wallet)
      end

      
    end
  end
end
