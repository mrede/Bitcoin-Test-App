#!/usr/bin/env ruby

require 'bundler'
# Add active record
require 'rubygems'
require 'active_record'
require 'yaml'


# Add models
require_relative '../../app/models/address'
require_relative '../../app/models/transaction'
require_relative '../../app/models/output'

Bundler.setup


require 'bitcoin'
require_relative '../../lib/bitcoin/tx_extensions'




if $0 == __FILE__
  Bitcoin::network = ARGV[0] || :bitcoin
  puts "Bitcoin::network #{Bitcoin::network }"
end

class TransactionListener < Bitcoin::Connection

  # Called when we receive a transaction
  def on_tx(tx)
    return false unless !tx.nil?
    p ['tx', tx.hash, Time.now]


    transaction = tx.create_transaction(tx.outputs)
    puts "Returned transaction #{transaction}"

    if transaction
      puts tx.to_json
       # save tx
      transaction.original_json=tx.to_json
      transaction.unique_hash = tx.hash
      return transaction.save()

      
    end
    false
  end

  # Dummy as current version seems to be missing
  def on_ping(x)
  end

  def on_block(block)
    p ['block', block.bip34_block_height]

    block.tx.each do |t|
      p [Time.now, 'Trans in block:  ', t.hash]
      # Check block
      trans = Transaction.where(unique_hash: t.hash).first
      unless trans.nil?
        puts "FOUND TRANS"
        if trans.confirmed.nil?
          trans.confirmed = 0
        end
        trans.confirmed += 1
        trans.save
      end
    end
    #p block.payload.each_byte.map{|i| "%02x" % [i] }.join(" ")
    #puts block.to_json
  end
  

end



if $0 == __FILE__

  # Load DB
  dbconfig = YAML::load(File.open('config/database.yml'))
  ActiveRecord::Base.establish_connection(dbconfig['development'])

  EM.run do

    host = '104.131.149.35'

    connections = []
    TransactionListener.connect(host, 18333, [])
    #p "Starting connection listener"
    #TransactionListener.connect_random_from_dns(connections)

  end
end