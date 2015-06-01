require 'rails_helper'

RSpec.describe "wallets/show", type: :view do
  before(:each) do
    @wallet = create(:wallet)
  end

  it "renders attributes" do
    render

    expect(rendered).to match /#{@wallet.name}/
  end
end
