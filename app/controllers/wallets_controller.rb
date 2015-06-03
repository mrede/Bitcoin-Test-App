require 'bitcoin'
require 'bitcoin/bitcoin_rpc'

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
    @wallet = Wallet.build_secure_wallet(wallet_params)

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
    @send_amount = (params[:amount].to_f * 100000000 ).to_i # Amount to send to address
    @round_up_amount = (params[:rounded_amount].to_f * 100000000 ).to_i - @send_amount # amount of round_up (send to donation bucket)
    @fee = (params[:tx_fee].to_f * 100000000).to_i # Amount to leave as fee
    @total_amount = @send_amount + @fee + @round_up_amount # The amount we will be deducting from users unspent outputs

    # Addres
    @target_address = params[:send_address]
    
    # Get inputs to spend
    inputs = Output.find_for_amount(@total_amount, @wallet)
    
    if inputs

      @change = Output.calculate_change(inputs, @total_amount)
      logger.info("Total:#{@total_amount}, Sending #{@send_amount}, Rounded #{@round_amount}, Fee #{@fee}")

      outputs  = []
      outputs << create_output(@send_amount, @target_address)
      if @round_up_amount > 0
        outputs << create_output(@round_up_amount, "msGQ5M46fTMJ3KWg325P1RBeZPt1Jc6ZDK")
      end
      if @change > 0
        outputs << create_output(@change, @wallet.addresses.first.val)
      end

      new_tx = build_new_tx(key, inputs, outputs)
      logger.debug("NEW TX: #{new_tx.to_json}")
      logger.debug("HEX #{bin_to_hex(new_tx.to_payload)}")
      
      Transaction.create_from_tx(inputs, new_tx)
      
      begin
        # Send
        rpc = BitcoinRPC.new('http://Ulysseys:YourPassword@127.0.0.1:8332') # TODO set config
        rpc.send_raw_trans(bin_to_hex(new_tx.to_payload))

        respond_to do |format|
          format.html { redirect_to @wallet, notice: 'Bitcoins have been sent.' }
          format.json { head :no_content }
        end
        return
      rescue Bitcoin::BitcoinRPC::BitcoinRPCError
        # TODO handle the error gracefully
      end
    end

    flash[:error] = 'Not enough Bitcoins available.'
    respond_to do |format|
        format.html { redirect_to @wallet  }
        format.json { head :no_content }
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
          prev_tx =Bitcoin::P::Tx.from_json(new_input.owner_transaction.original_json)
          t.input do |i|
            i.prev_out prev_tx
            i.prev_out_index get_address_index(prev_tx.outputs, new_input.address.val)
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

      end

      new_tx
    end

    # Matches address to index in outputs
    def get_address_index(outputs, address)
      outputs.each_with_index {|out, index|
        if (out.parsed_script.get_addresses & [address]).any?
          # we found it
          return index
        end
      }
      return 0
    end

    def bin_to_hex(s)
      s.each_byte.map { |b| b.to_s(16).rjust(2,'0') }.join
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wallet_params
      params.require(:wallet).permit(:public_key, :private_key, :name)
    end
end
