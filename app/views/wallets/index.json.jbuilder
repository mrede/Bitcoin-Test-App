json.array!(@wallets) do |wallet|
  json.extract! wallet, :id
  json.url wallet_url(wallet, format: :json)
end
