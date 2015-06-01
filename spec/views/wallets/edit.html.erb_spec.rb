require 'rails_helper'

RSpec.describe "wallets/edit", type: :view do
  before(:each) do
    @wallet = create(:wallet)
  end

  it "renders the edit wallet form" do
    render

    assert_select "form[action=?][method=?]", wallet_path(@wallet), "post" do
    end
  end
end
