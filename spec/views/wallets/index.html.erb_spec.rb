require 'rails_helper'

RSpec.describe "wallets/index", type: :view do
  before(:each) do
    assign(:wallets, [
      create(:wallet),
      create(:wallet)
    ])
  end

  it "renders a list of wallets" do
    render
  end
end
