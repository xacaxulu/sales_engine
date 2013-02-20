require 'date'
require 'bigdecimal'

module SalesEngine
  class Merchant
    attr_accessor :id, :name

    def initialize(id,name)
      @id = id.to_i
      @name = name
    end

    def self.load
      @merchants = []
      contents = CSV.open('./data/merchants.csv', :headers => true)
      contents.each do |row|
        @merchants << Merchant.new(row[0],row[1])
      end
      load_revenue
      load_most_items
    end

    def self.load_revenue
      invoice_item_revenues = Hash.new(0)
      InvoiceItem.all_successful.each do |invoice_item|
        amount = invoice_item.quantity * invoice_item.unit_price
        invoice_item_revenues[invoice_item.invoice_id] += amount 
      end
      merchant_revenue_hash = Hash.new(0)
      invoice_item_revenues.each_pair do |k,v|
        merchant_revenue_hash[Invoice.find_by_id(k).merchant_id] += BigDecimal.new(v.to_s.insert(-3,'.'))
      end
      @revenue = merchant_revenue_hash
    end

    def self.most_revenue(i)
      list = []
      sorted_array = Hash[@revenue.sort_by { |k,v| v }.reverse]
      sorted_array.keys[0..i-1].each {|key| list << Merchant.find_by_id(key)}   
      return list
    end

    def self.load_most_items
      most_items_hash = Hash.new(0)
      InvoiceItem.all_successful.each do |invoice_item|
        amount = invoice_item.quantity
        most_items_hash[invoice_item.invoice_id] += amount
      end
      merchant_quantity_hash = Hash.new(0)
      most_items_hash.each_pair do |k,v|
        merchant_quantity_hash[Merchant.find_by_id(Invoice.find_by_id(k.to_i).merchant_id).id] += v 
      end
      @merchant_most_items_sold = merchant_quantity_hash
    end

    def self.most_items(int)
      list = []
      sorted_array = Hash[@merchant_most_items_sold.sort_by { |k,v| v }.reverse]
      sorted_array.keys[0..int-1].each {|key| list << Merchant.find_by_id(key)}   
      return list 
    end

    def self.revenue(date)
      parsed_date = Date.parse(date).strftime("%Y-%m-%d")
      amount = Hash.new(0)
      rev=->(x,y){x*y}
      InvoiceItem.all_successful.each do |item|
        if Invoice.find_by_id(item.invoice_id).created_at == parsed_date
          amount['amount'] += rev.(item.quantity.to_i,item.unit_price.to_i)
        else
        end
      end
      return BigDecimal.new(amount['amount'].to_s.insert(-3,'.'))
    end

    def revenue(date=nil)
      rev=->(x,y){x*y}
      if date.nil?
        hash = Hash.new(0)
        InvoiceItem.all_successful.each do |i| 
          hash[Merchant.find_by_id(Invoice.find_by_id(i.invoice_id).merchant_id).id] += (rev.(i.unit_price,i.quantity))
        end
        return BigDecimal.new(hash[self.id].to_s.insert(-3,'.'))
      else 
        @date = Date.parse(date).strftime("%Y-%m-%d")
        @array = []
        InvoiceItem.all_successful.each do |item|
          if Invoice.find_by_id(item.invoice_id).created_at == @date && Invoice.find_by_id(item.invoice_id).merchant_id == self.id
            @array << rev.(item.quantity,item.unit_price)
          else
          end
        end
        return BigDecimal.new(@array.inject(:+).to_s.insert(-3,'.'))
      end
    end

    def self.count
      @merchants.count
    end

    def self.random
      @merchants.sample
    end 

    def self.find_by_name(name)
      @merchants.find {|m| m.name == name}
    end

    def self.find_by_id(id)
      @merchants.find {|m| m.id == id}
    end

    def self.find_all_by_id(id)
      @merchants.select {|m| m.id == id}
    end

    def self.find_all_by_name(name)
      @merchants.select {|m| m.name == name}
    end

    def items
      Item.find_all_by_merchant_id(self.id)
    end

    def invoices
      Invoice.find_all_by_merchant_id(self.id)
    end

    def paid_invoices
      Invoice.find_all_paid_by_merchant_id(self.id)
    end

    def pending_invoices
      Invoice.find_all_pending_by_merchant_id(self.id)
    end

    def paid_invoices_by_customer
      customer_data = Hash.new(0)
      paid_invoices.each do |invoice|
        customer_data[invoice.customer_id] += 1
      end
      customer_data
    end

    def favorite_customer
      return nil if paid_invoices_by_customer.empty?
      customer_data_max = paid_invoices_by_customer.max_by{|k,v| v}
      Customer.find_by_id(customer_data_max.first)
    end

    def customers_with_pending_invoices
      customer = []
      pending_invoices.collect {|i| customer << Customer.find_by_id(i.customer_id)}
      return customer
    end
  end
end
