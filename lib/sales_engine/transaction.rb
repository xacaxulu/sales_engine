require 'date'

module SalesEngine
  class Transaction
    attr_accessor :id, :invoice_id, :credit_card_number, :credit_card_number_expiration_date, :result

    def initialize(id, invoice_id, credit_card_number, credit_card_number_expiration_date, result)
      @id = id.to_i
      @invoice_id = invoice_id.to_i
      @credit_card_number = credit_card_number.to_i
      @credit_card_number_expiration_date = credit_card_number_expiration_date
      @result = result
    end

    def self.load
      @transactions = []
      @successful_transactions = []
      @failed_transactions = []
      contents = CSV.open('./data/transactions.csv', :headers => true)
      contents.each do |row|
        @transactions << Transaction.new(row[0],row[1],row[2],row[3],row[4])
        if row[4] == 'success'
          @successful_transactions << Transaction.new(row[0],row[1],row[2],row[3],row[4])
        elsif row[4] == 'failed' && !Transaction.all_successful_ids.include?(row[0])
          @failed_transactions << Transaction.new(row[0],row[1],row[2],row[3],row[4])
        else
        end
      end
    end

    def self.all
      @transactions
    end

    def self.all_successful(input=nil)
      if input
        @successful_transactions << input
      else
        @successful_transactions
      end
    end

    def self.all_failed
      @failed_transactions
    end

    def self.add_to_data(transaction)
      if transaction.result == 'success'
        Transaction.all_successful(transaction)
      else
      end
    end

    def self.all_successful_ids
      @successful_transactions.collect {|t| t.id}
    end

    def self.all_successful_invoice_ids
      @successful_transactions.collect {|t| t.invoice_id}
    end

    def self.all_failed_invoice_ids
      @failed_transactions.collect {|t| t.invoice_id}
    end

    def self.all_invoice_ids_for_transactions
      all.collect {|i| i.invoice_id}
    end

    def self.count
      @transactions.count
    end

    def self.random
      @transactions.sample
    end

    def self.find_by_id(id)
      @transactions.find {|t| t.id == id}
    end

    def self.find_by_invoice_id(invoice_id)
      @transactions.find {|t| t.invoice_id == invoice_id}
    end

    def self.find_by_credit_card_number(credit_card_number)
      @transactions.find {|t| t.credit_card_number == credit_card_number.to_i}
    end

    def self.find_by_result(result)
      @transactions.find {|t| t.result == result}
    end

    def self.find_all_by_invoice_id(invoice_id)
      @transactions.select {|t| t.invoice_id == invoice_id}
    end

    def self.find_all_by_result(result)
      @transactions.select {|t| t.result == result}
    end

    def invoice
      Invoice.find_by_id(self.invoice_id)
    end

    def transactions
      @transactions ||= Transaction.find_all_by_invoice_id(id)
    end
  end
end
