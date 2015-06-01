FactoryGirl.define do
  factory :transaction, aliases: [:owner_transaction, :as_transaction_input] do
    unique_hash {(0...50).map { ('a'..'z').to_a[rand(26)] }.join}
    
    original_json "{ none: '' }"
    
  end

end
