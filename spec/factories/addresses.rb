FactoryGirl.define do
  factory :address do
    association :wallet
    val {(0...15).map { ('a'..'z').to_a[rand(26)] }.join}
  end

end
