FactoryGirl.define do
  factory :transaction, aliases: [:owner_transaction, :as_transaction_input] do
    unique_hash {(0...50).map { ('a'..'z').to_a[rand(26)] }.join}
    confirmed 1
    original_json '{
  "hash":"6f8ecad2cd68d40d4ce742bd3085b497f997c436b6fbf95a0081dee489a708ab",
  "ver":1,
  "vin_sz":1,
  "vout_sz":2,
  "lock_time":0,
  "size":369,
  "in":[
    {
      "prev_out":{
        "hash":"52b78777cfbf8c01755a7772b908ba88a586883f8a0df729725345e2f95e2942",
        "n":0
      },
      "scriptSig":"0 304402207499408c5e2b41265ae166d5c07be6e18559c2e8396bb7b8a6f308cbb9e46f75022023b3f2b848363156664ca9145c5b4384bb086a89a6830993a5e1f9316f8d3eaa01 3044022057e73310ecac6e46c5a6bf296841956ac27db56b07cab566cfdce3cd14cfbeda02202da8c391ccd9b04e9569429670d535221b026a63685a4d4170e18fea75c138d201 5221022dc3f79434565a3c7c4843d29f7a15a3dfa94ba0663291538ea742c71b76397f2102e780226ac210d81bfd4a62263531422b2a36ce5ccd9da61dcbb5a896e6b7da312103ade721ea77bcafb610541f75d65a734accdf41e61b2af5056c985f1200327ca653ae"
    }
  ],
  "out":[
    {
      "value":"0.04130000",
      "scriptPubKey":"OP_HASH160 8cd2e74a6ab099a345fc583304438f87bf2041fc OP_EQUAL"
    },
    {
      "value":"0.01000000",
      "scriptPubKey":"OP_DUP OP_HASH160 642eb1cae37b90e2fe257de8167668626b0adbd9 OP_EQUALVERIFY OP_CHECKSIG"
    }
  ]
}'
    
  end

end
