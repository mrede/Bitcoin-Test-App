FactoryGirl.define do
  factory :output do
    transaction_id 1
    association :address
    association :owner_transaction
    association :as_transaction_input
    value {rand(1..1000)* 100000} 

    factory :unspent_output do

      as_transaction_input  nil

      
    end
  end

end
