class Output < ActiveRecord::Base
  belongs_to :owner_transaction, foreign_key: "transaction_id", class_name: "Transaction"
  belongs_to :as_transaction_input, foreign_key: "as_transaction_input_id", class_name: "Transaction"
  belongs_to :address

  def value_mbtc
    self.value / 100000
  end

  # Find any outputs belonging to a wallet that can equal or lower amount
  def self.find_for_amount(amount, wallet)
    return false unless !amount.nil?
    outputs = []

    # Check if there is a single amount we can use
    output = Output.joins(address: :wallet).where("value > ? AND wallets.id = ? AND as_transaction_input_id IS NULL", amount, wallet.id).order(value: :asc).first
    return [output] unless output.nil?

    # We don't have a single amount - find a group of outputs that satisfy
    outputs = Output.find_grouped_for_amount(amount, wallet)
  end

  # Works out how much will be left from these unspent outputs
  def self.calculate_change(inputs, total_amount)

    total = inputs.inject(0){|sum,e| sum += e.value }
    total - total_amount
  end

  def to_s
    self.value
  end

private

  # Find a group of outputs that total the amount. We could make this a lot better, but will suffice for demo
  def self.find_grouped_for_amount(amount, wallet)
    outputs = Output.joins(address: :wallet).where("wallets.id = ? AND as_transaction_input_id IS NULL", wallet.id).order(value: :desc)
    
    # Find 
    total = 0
    grouped_outputs = []
    outputs.each do |output|
      total+=output.value
      grouped_outputs << output
      
      if total > amount 
        return grouped_outputs
      end   
    end
    false
    
  end

  
end
