require 'rails_helper'

RSpec.describe "wallets/index", type: :view do
  before(:each) do
    assign(:wallets, [
      Wallet.create!(),
      Wallet.create!()
    ])
  end

  it "renders a list of wallets" do
    render
  end
end
