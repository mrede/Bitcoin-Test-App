require 'rails_helper'

require 'bitcoin/bitcoin_rpc'

#require 'listener/transaction_listener'

RSpec.describe Bitcoin::BitcoinRPC, type: :class do

  describe "#method_missing" do
    it "returns result" do
      rpc = BitcoinRPC.new('http://Ulysseys:YourPassword@127.0.0.1:8332') # TODO set config
      block_hash = rpc.getblockhash(12345)

      expect(block_hash).to eq("0000000020dca20e6617854f0d518155af742c899eedc22521f9f5ad44b15f3c")
    end
  end

  describe "#send_raw_trans" do
    it "returns result" do
      # create trans and tx
      trans = create(:transaction)
      tx = Bitcoin::P::Tx.from_json(trans.original_json)
      rpc = BitcoinRPC.new('http://Ulysseys:YourPassword@127.0.0.1:8332') # TODO set config
      
      expect {
        # Sending old Transaction which will fail
        block_hash = rpc.send_raw_trans("0100000001bcef66ebc7179da09340ad57264239db9d6e93c40ef53d078cfe345f686c22d6020000008a47304402207a58deeea98285bba41b5d173b2344d5eed4cc7a10299feee877aa73f6ef909e02207e76ddc668fb65bfdfc7381da057259545dcb089f5642e894be00cdc9db677c4014104b47769b1f0284a3be1256c5458222547612028db9c218b9fe544a6ea49b6f553dd72fa169d15fa6bfcb8753f26c0bc5045b5b5788e621a0489580d1fe26b569bffffffff0320b200000000000017a914fb111cbfd17b3b73537e0826cee4ffc5ae8820d88730110000000000001976a91480e0ca718a3fb62bc61ba0dd3f0f12ee5fae6a5488ac10270000000000001976a914642eb1cae37b90e2fe257de8167668626b0adbd988ac00000000")
      }.to raise_exception(Bitcoin::BitcoinRPC::BitcoinRPCError)
      
    end
  end
end