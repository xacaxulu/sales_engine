require 'bigdecimal'
require 'csv'

module SalesEngine
  class Item
    attr_accessor :id, :name, :description, :unit_price, :merchant_id

    def initialize(id, name, description, unit_price, merchant_id)
      @id = id.to_i
      @name = name
      @description = description
      @unit_price = BigDecimal.new(unit_price.to_s.insert(-3,'.'))
      @merchant_id = merchant_id.to_i
    end

    def self.load
      @items = []
      contents = CSV.open('./data/items.csv', 'r', :headers => true)
      contents.each do |row|
        @items << Item.new(row[0],row[1],row[2],row[3],row[4])
      end
    end

    def self.count
      @items.count
    end

    def self.all
      @items
    end

    def self.random
      @items.sample
    end

    def self.find_by_id(id)
      @items.find {|i| i.id == id}
    end

    def self.find_by_name(name)
      @items.find {|i| i.name == name}
    end

    def self.find_by_description(description)
      @items.find {|i| i.description == description}
    end

    def self.find_by_merchant_id(merchant_id)
      @items.find {|i| i.merchant_id == merchant_id}
    end

    def self.find_by_unit_price(unit_price)
      @items.find {|i| i.unit_price == unit_price}
    end

    def self.find_all_by_name(name)
      @items.select {|i| i.name == name}
    end

    def self.find_all_by_description(description)
      @items.select {|i| i.description == description}
    end

    def self.find_all_by_unit_price(unit_price)
      @items.select {|i| i.unit_price == BigDecimal.new(unit_price.to_s)}
    end

    def self.find_all_by_merchant_id(merchant_id)
      @items.select {|i| i.merchant_id == merchant_id}
    end

    def invoice_items
      InvoiceItem.find_all_by_item_id(self.id)
    end

    def successful_invoice_items
      InvoiceItem.find_all_successful_by_item_id(self.id)
    end

    def merchant
      Merchant.find_by_id(self.merchant_id)
    end

    def revenue
      successful_invoice_items.collect {|ii| ii.subtotal}.inject(:+) || 0
    end

    def quantity
      successful_invoice_items.collect {|ii| ii.quantity}.inject(:+) || 0
    end

    def self.most_revenue(total_num)
      @items_by_revenue ||= all.sort_by {|item| item.revenue}.reverse
      @items_by_revenue.take(total_num)
    end

    def self.most_items(num)
      @items_by_quantity ||= all.sort_by {|item| item.quantity}.reverse
      @items_by_quantity.take(num)
    end

    def best_day
      results = Hash.new(0)
      invoice_items.each do |item|
        results[Invoice.find_by_id(item.invoice_id).created_at] += item.quantity
      end
      Date.parse(results.sort_by { |k, v| v }.last.first)
    end
  end
end



