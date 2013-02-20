module SalesEngine
  class InvoiceItem
    attr_reader :id, :item_id, :invoice_id, :quantity, :unit_price
    def initialize(id,item_id,invoice_id,quantity,unit_price)
      @id = id.to_i
      @item_id = item_id.to_i
      @invoice_id = invoice_id.to_i
      @quantity = quantity.to_i
      @unit_price = unit_price.to_i
    end

    def self.load
      @invoice_items = []
      @successful_invoice_items = []
      @pending_invoice_items = []
      contents = CSV.open('./data/invoice_items.csv', :headers => true)
      contents.each do |row|
        @invoice_items << InvoiceItem.new(row[0],row[1],row[2],row[3],row[4])
        if Invoice.all_successful_ids.include?(row[2].to_i)
          @successful_invoice_items << InvoiceItem.new(row[0],
                                                       row[1],
                                                       row[2],
                                                       row[3],
                                                       row[4])
        elsif !Invoice.all_ids.include?(row[2].to_i) || !Invoice.all_successful_ids.include?(row[2].to_i)
          @pending_invoice_items << InvoiceItem.new(row[0],row[1],row[2],row[3],row[4])
        else
        end
      end
    end

    def self.all
      @invoice_items
    end

    def self.all_successful
      @successful_invoice_items
    end

    def self.all_pending
      @pending_invoice_items
    end

    def self.filter_by_item(item_id)
      InvoiceItem.all_successful.select { |ii| ii.item_id == item_id }
    end
   
    def self.revenue_per_item(item_id)
      filter_by_item(item_id).collect { |ii| ii.unit_price * ii.quantity }.inject(:+)
    end

    def self.count
      @invoice_items.count
    end

    def self.random
      @invoice_items.sample
    end

    def self.find_by_id(id)
      @invoice_items.find {|i| i.id == id}
    end

    def self.find_by_created_at(date)
      @invoice_items.find {|i| i.created_at == date}
    end

    def self.find_by_item_id(item_id)
      @invoice_items.find {|i| i.item_id == item_id}
    end

    def self.find_by_invoice_id(invoice_id)
      @invoice_items.find {|i| i.invoice_id == invoice_id}
    end

    def self.find_by_quantity(quantity)
      @invoice_items.find {|i| i.quantity == quantity}
    end

    def self.find_by_unit_price(unit_price)
      @invoice_items.find {|i| i.unit_price == unit_price}
    end

    def self.find_all_by_invoice_id(invoice_id)
      @invoice_items.select {|i| i.invoice_id == invoice_id}
    end

    def self.find_all_by_item_id(item_id)
      @invoice_items.select {|i| i.item_id == item_id}
    end

    def self.find_all_successful_by_item_id(item_id)
      @successful_invoice_items.select {|i| i.item_id == item_id}
    end

    def self.find_all_by_quantity(quantity)
      @invoice_items.select {|i| i.quantity == quantity}
    end

    def subtotal
      self.quantity*self.unit_price
    end

    def invoice
      Invoice.find_by_id(self.invoice_id)
    end

    def item
      Item.find_by_id(self.item_id)
    end

    
  end
end
