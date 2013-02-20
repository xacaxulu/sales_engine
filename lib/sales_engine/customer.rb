module SalesEngine

  class Customer
    attr_accessor :id, :first_name, :last_name

    def initialize(id,first_name,last_name)
      @id = id.to_i
      @first_name = first_name
      @last_name = last_name
    end

    def self.load
      @customers = []
      contents = CSV.open('./data/customers.csv', :headers => true)
      contents.each do |row|
        @customers << Customer.new(row[0],row[1],row[2])
      end
    end

    def self.count
      @customers.count
    end

    def self.random
      @customers.sample
    end

    def self.find_by_id(id)
      @customers.find {|c| c.id == id}
    end

    def self.find_by_first_name(first_name)
      @customers.find {|c| c.first_name.downcase == first_name.downcase }
    end

    def self.find_by_last_name(last_name)
      @customers.find {|c| c.last_name.downcase == last_name.downcase }
    end

    def self.find_all_by_last_name(last_name)
      @customers.select {|c| c.last_name.downcase == last_name.downcase}
    end

    def self.find_all_by_first_name(first_name)
      @customers.select {|c| c.first_name.downcase == first_name.downcase}
    end

    def invoices
      Invoice.find_all_by_customer_id(self.id)
    end

    def transactions
      invoices.flat_map(&:transactions)
    end

    def favorite_merchant
      merchant_map = Hash.new
      invoices.each do |invoice|
        merchant_id = invoice.merchant_id
        if merchant_map.key?(merchant_id)
          merchant_map[merchant_id] += 1
        else
          merchant_map[merchant_id] = 1
        end
      end

      unless merchant_map.empty?
        sorted_map = merchant_map.sort_by { |key, value| value }.reverse
        Merchant.find_by_id(sorted_map.first[0])
      end
    end

    def find_by_merchant_id(merchant_id)
      Customer.find_by_id(Invoice.find_by_merchant_id(merchant_id).customer_id)
    end
  end
end
