require 'csv'
require 'sales_engine/transaction'
require 'sales_engine/customer'
require 'sales_engine/invoice'
require 'sales_engine/invoice_item'
require 'sales_engine/merchant'
require 'sales_engine/item'


module SalesEngine
  def self.startup
    Transaction.load
    Item.load
    Invoice.load
    InvoiceItem.load
    Customer.load
    Merchant.load
  end
end
