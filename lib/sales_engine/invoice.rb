module SalesEngine
  class Invoice
    attr_accessor :id, :customer_id, :merchant_id, :status, :created_at

    def initialize(id, customer_id, merchant_id, status, created_at)
      @id = id.to_i
      @customer_id = customer_id.to_i
      @merchant_id = merchant_id.to_i
      @status = status
      @created_at = Date.parse(created_at).strftime("%Y-%m-%d")
    end

    def self.load
      @invoices = []
      @successful_invoices = []
      @pending_invoices = []
      contents = CSV.open('./data/invoices.csv', :headers => true)
      contents.each do |row|
        @invoices << Invoice.new(row[0],
                                 row[1],
                                 row[2],
                                 row[3],
                                 row[4])
        if Transaction.all_successful_invoice_ids.include?(row[0].to_i)
          @successful_invoices << Invoice.new(row[0],
                                              row[1],
                                              row[2],
                                              row[3],
                                              row[4])
        elsif !Transaction.all_successful_invoice_ids.include?(row[0].to_i)
          @pending_invoices << Invoice.new(row[0],
                                           row[1],
                                           row[2],
                                           row[3],
                                           row[4])
        else
        end
      end
    end

    def self.create(*args)
      #binding.pry
      invoice = Invoice.new(Invoice.count+1,
                            args[0][:customer].id,
                            args[0][:merchant].id,
                            'pending',Date.new.strftime("%Y-%m-%d"))
      args[0][:items].each do |item|
        InvoiceItem.create(InvoiceItem.count+1,
                          item.id,invoice.id,1,
                          item.unit_price)
      end
      invoice
    end

    def self.all
      @invoices
    end

    def self.all_successful
      @successful_invoices
    end

    def self.all_pending
      @pending_invoices
    end

    def self.all_successful_ids
      all_successful.collect {|i| i.id}
    end

    def self.all_pending_ids
      all_pending.collect {|i| i.id}
    end

    def self.all_ids
      all.collect {|i| i.id}
    end

    def self.count
      @invoices.count
    end

    def self.random
      @invoices.sample
    end

    def self.find_by_id(id)
      @invoices.find {|i| i.id == id}
    end

    def self.find_by_customer_id(customer_id)
      @invoices.find {|i| i.customer_id == customer_id}
    end

    def self.find_by_merchant_id(merchant_id)
      @invoices.find {|i| i.merchant_id == merchant_id}
    end

    def self.find_by_status(status)
      @invoices.find {|i| i.status == status}
    end

    def self.find_all_by_id(id)
      @invoices.select {|i| i.id == id}
    end

    def self.find_all_by_customer_id(customer_id)
      @invoices.select {|i| i.customer_id == customer_id}
    end

    def self.find_all_by_merchant_id(merchant_id)
      @invoices.select {|i| i.merchant_id == merchant_id}
    end

    def self.find_all_paid_by_merchant_id(merchant_id)
      all_successful.select {|i| i.merchant_id == merchant_id}
    end

    def self.find_all_pending_by_merchant_id(merchant_id)
      all_pending.select {|i| i.merchant_id == merchant_id}
    end

    def self.find_all_by_status(status)
      @invoices.select {|i| i.status == status}
    end

    def self.find_all_by_created_at(date)
      @invoices.select {|i| i.created_at == date}
    end

    def transactions
      Transaction.find_all_by_invoice_id(self.id)
    end

    def invoice_items
      InvoiceItem.find_all_by_invoice_id(self.id)
    end

    def items
      InvoiceItem.find_all_by_invoice_id(self.id).collect do |i|
        Item.find_by_id(i.item_id.to_i)
      end
    end

    def customer
      Customer.find_by_id(self.customer_id)
    end

    def charge(*args)
        transaction = Transaction.create(Transaction.count+1, self.id,
                                      args[0][:credit_card_number],
                                      args[0][:credit_card_expiration_date],
                                      args[0][:result])
    end
  end
end
