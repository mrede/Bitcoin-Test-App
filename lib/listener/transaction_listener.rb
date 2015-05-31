#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

require 'bitcoin'

Bitcoin::network = ARGV[0] || :bitcoin

class TransactionListener < Bitcoin::Connection

  # Called when we receive a transaction
  def on_tx(tx)
    p ['tx', tx.hash, Time.now]
     puts tx.to_json

     tx.outputs.each do |out|

       puts "ADDRESSES #{out.parsed_script.get_addresses}"
     end
  end

end

if $0 == __FILE__
  EM.run do

    host = '127.0.0.1'

    connections = []
    #RawJSON_Connection.connect(host, 18333, [])
    p "Starting connection listener"
    TransactionListener.connect_random_from_dns(connections)

  end
end