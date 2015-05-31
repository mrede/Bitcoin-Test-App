FactoryGirl.define do
  factory :address do
    association :wallet
    val "MyString"
  end

end
