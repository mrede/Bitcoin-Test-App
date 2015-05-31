#!/usr/bin/env ruby

require 'bundler'
# Add active record
require 'rubygems'
require 'active_record'
require 'yaml'

# Add models
require_relative '../../app/models/address'
#require_relative '../../app/models/transactions'

Bundler.setup

require 'bitcoin'



Bitcoin::network = ARGV[0] || :bitcoin


class TransactionListener < Bitcoin::Connection

  # Called when we receive a transaction
  def on_tx(tx)
    return false unless !tx.nil?
    p ['tx', tx.hash, Time.now]
    puts tx.to_json

    Address.check_outputs(tx.outputs)
  end

  # Dummy as current version seems to be missing
  def on_ping(x)
  end

  

end


if $0 == __FILE__

  # Load DB
  dbconfig = YAML::load(File.open('config/database.yml'))
  ActiveRecord::Base.establish_connection(dbconfig['development'])

  EM.run do

    host = '127.0.0.1'

    connections = []
    #RawJSON_Connection.connect(host, 18333, [])
    p "Starting connection listener"
    TransactionListener.connect_random_from_dns(connections)

  end
end