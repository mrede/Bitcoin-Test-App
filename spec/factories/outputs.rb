FactoryGirl.define do
  factory :output do
    transaction_id 1
    address_id 1
    value {rand(1..1000)* 100000} 
  end

end
