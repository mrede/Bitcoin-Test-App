require 'bitcoin'

include Bitcoin::Builder

class WalletsController < ApplicationController
  before_action :set_wallet, only: [:show, :edit, :update, :destroy]

  # GET /wallets
  # GET /wallets.json
  def index
    @wallets = Wallet.all
  end

  # GET /wallets/1
  # GET /wallets/1.json
  def show
  end

  # GET /wallets/new
  def new
    @wallet = Wallet.new
  end

  # GET /wallets/1/edit
  def edit
  end

  # POST /wallets
  # POST /wallets.json
  def create
    @wallet = Wallet.new(wallet_params)

    respond_to do |format|
      if @wallet.save
        format.html { redirect_to @wallet, notice: 'Wallet was successfully created.' }
        format.json { render :show, status: :created, location: @wallet }
      else
        format.html { render :new }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wallets/1
  # PATCH/PUT /wallets/1.json
  def update
    respond_to do |format|
      if @wallet.update(wallet_params)
        format.html { redirect_to @wallet, notice: 'Wallet was successfully updated.' }
        format.json { render :show, status: :ok, location: @wallet }
      else
        format.html { render :edit }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wallets/1
  # DELETE /wallets/1.json
  def destroy
    @wallet.destroy
    respond_to do |format|
      format.html { redirect_to wallets_url, notice: 'Wallet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Send money
  def send_bitcoins
    Bitcoin.network = :testnet3 # TODO FIX for config
    # "send_address"=>"ABC", "amount"=>"0.1", "round"=>"5"
    @wallet = Wallet.find(params[:id])

    key = @wallet.bitcoin_key

    # Work out all amounts
    @send_amount = (params[:amount].to_f * 1000000000 ) # Amount to send to address
    @round_up_amount = (params[:rounded_amount].to_f * 1000000000 ) - @send_amount # amount of round_up (send to donation bucket)
    @fee = params[:tx_fee].to_f * 1000000000 # Amount to leave as fee
    @total_amount = @send_amount + @fee + @round_up_amount # The amount we will be deducting from users unspent outputs

    # Addres
    @target_address = params[:send_address]
    
    # Get inputs to spend
    inputs = Output.find_for_amount(@total_amount, @wallet)

    puts "NO. of inputs #{inputs}"

    if inputs

      @change = Output.calculate_change(inputs, @total_amount)
      puts "CHANGE: #{@change}, #{@total_amount}"

      outputs  = []
      outputs << create_output(@send_amount, @target_address)
      outputs << create_output(@round_up_amount, "msGQ5M46fTMJ3KWg325P1RBeZPt1Jc6ZDK")
      outputs << create_output(@change, @wallet.addresses.first.val)

      new_tx = build_new_tx(key, inputs, outputs)
      puts "NEW TX: #{new_tx.to_json}"
      # if inputs
      #   inputs.each do |out|
      #     p "HELLO #{out.owner_transaction.unique_hash}"
      #     # Try and create from TX
      #     tx = Bitcoin::P::Tx.from_json(out.owner_transaction.original_json)
      #     p "TX: #{tx.to_json}"
      #   end
      # end
      # respond_to do |format|
      #   format.html { redirect_to @wallet, notice: 'Bitcoins have been sent.' }
      #   format.json { head :no_content }
      # end
    else
      respond_to do |format|
        format.html { redirect_to @wallet, error: 'No available outputs.' }
        format.json { head :no_content }
      end
    end

    
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallet
      @wallet = Wallet.find(params[:id])
    end

    def create_output(amount, address)
      {value: amount, address: address}
    end

    def build_new_tx(key, inputs, outputs)
      new_tx = build_tx do |t|

        # add the input you picked out earlier

        inputs.each do |new_input|
          puts "PReb out#{new_input.owner_transaction.unique_hash}"
          prev_tx =Bitcoin::P::Tx.from_json(new_input.owner_transaction.original_json)
          puts "ORIGINAL JSON: #{prev_tx.to_json}"
          t.input do |i|
            i.prev_out prev_tx
            i.prev_out_index 1 # TODO
            i.signature_key key
          end
        end

        outputs.each do |new_output|
          # add an output that sends some bitcoins to another address
          puts "New output #{new_output}, #{new_output[:value]}, #{new_output[:address]} #{key.addr}"
          t.output do |o|
            o.value new_output[:value] # 0.5 BTC in satoshis
            o.script {|s| s.recipient new_output[:address] }
          end
        end
        # t.output do |o|
        # o.value 4840000 # 0.49 BTC, leave 0.01 BTC as fee
        # o.script {|s| s.recipient key.addr }
        # end

        # # add another output spending the remaining amount back to yourself
        # # if you want to pay a tx fee, reduce the value of this output accordingly
        # # if you want to keep your financial history private, use a different address
        # t.output do |o|
        #   o.value 4840000 # 0.49 BTC, leave 0.01 BTC as fee
        #   o.script {|s| s.recipient key.addr }
        # end

      end

      new_tx
    end

    def bin_to_hex(s)
      s.each_byte.map { |b| b.to_s(16).rjust(2,'0') }.join
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wallet_params
      params.require(:wallet).permit(:public_key, :private_key, :name)
    end
end
