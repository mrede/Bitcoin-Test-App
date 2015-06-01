require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe WalletsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Wallet. As you add validations to Wallet, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      private_key: 'RANDOMHASH',
      public_key: 'ANOTHERRANDOM HASH',
      name: "BEN"
    }
  }

  let(:invalid_attributes) {
    {
      private_key: '',
      public_key: ''
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # WalletsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all wallets as @wallets" do
      wallet = create(:wallet)
      get :index, {}, valid_session
      expect(assigns(:wallets)).to eq([wallet])
    end
  end

  describe "GET #show" do
    it "assigns the requested wallet as @wallet" do
     wallet = create(:wallet)
      get :show, {:id => wallet.to_param}, valid_session
      expect(assigns(:wallet)).to eq(wallet)
    end
  end

  describe "GET #new" do
    it "assigns a new wallet as @wallet" do
      get :new, {}, valid_session
      expect(assigns(:wallet)).to be_a_new(Wallet)
    end
  end

  describe "GET #edit" do
    it "assigns the requested wallet as @wallet" do
     wallet = create(:wallet)
      get :edit, {:id => wallet.to_param}, valid_session
      expect(assigns(:wallet)).to eq(wallet)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Wallet" do
        expect {
          post :create, {:wallet => valid_attributes}, valid_session
        }.to change(Wallet, :count).by(1)
      end

      it "assigns a newly created wallet as @wallet" do
        post :create, {:wallet => valid_attributes}, valid_session
        expect(assigns(:wallet)).to be_a(Wallet)
        expect(assigns(:wallet)).to be_persisted
      end

      it "redirects to the created wallet" do
        post :create, {:wallet => attributes_for(:wallet)}, valid_session
        expect(response).to redirect_to(Wallet.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved wallet as @wallet" do
        post :create, {:wallet => invalid_attributes}, valid_session
        expect(assigns(:wallet)).to be_a_new(Wallet)
      end

      it "re-renders the 'new' template" do
        post :create, {:wallet => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested wallet" do
        wallet = create(:wallet)
        put :update, {:id => wallet.to_param, :wallet => { name: "UPDATE TEST"}}, valid_session
        wallet.reload
        expect(wallet.name).to eq("UPDATE TEST")
      end

      it "assigns the requested wallet as @wallet" do
       wallet = create(:wallet)
        put :update, {:id => wallet.to_param, :wallet => valid_attributes}, valid_session
        expect(assigns(:wallet)).to eq(wallet)
      end

      it "redirects to the wallet" do
       wallet = create(:wallet)
        put :update, {:id => wallet.to_param, :wallet => valid_attributes}, valid_session
        expect(response).to redirect_to(wallet)
      end
    end

    context "with invalid params" do
      it "assigns the wallet as @wallet" do
       wallet = create(:wallet)
        put :update, {:id => wallet.to_param, :wallet => invalid_attributes}, valid_session
        expect(assigns(:wallet)).to eq(wallet)
      end

      it "re-renders the 'edit' template" do
       wallet = create(:wallet)
        put :update, {:id => wallet.to_param, :wallet => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested wallet" do
     wallet = create(:wallet)
      expect {
        delete :destroy, {:id => wallet.to_param}, valid_session
      }.to change(Wallet, :count).by(-1)
    end

    it "redirects to the wallets list" do
     wallet = create(:wallet)
      delete :destroy, {:id => wallet.to_param}, valid_session
      expect(response).to redirect_to(wallets_url)
    end
  end

end
