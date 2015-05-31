FactoryGirl.define do
  factory :transaction do
    hash "MyString"
    value "9.99"
    raw ""
    association :address
  end

end
