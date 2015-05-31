FactoryGirl.define do
  factory :address do
    association :wallet
    val '(\d{8}$)'
  end

end
