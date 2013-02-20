require './test/test_helper'

class InvoiceTest < MiniTest::Unit::TestCase

  def test_it_exists
    invoice = SalesEngine::Invoice.new(3,9,10, "shipped", "2012-03-25 09:54:09 UTC")
    assert_kind_of SalesEngine::Invoice, invoice
  end

  def test_load_method_works
    assert_equal 4843, SalesEngine::Invoice.count
  end

  def test_all_method_works
    @invoices = SalesEngine::Invoice.all
    assert_kind_of Array,@invoices
    assert_equal @invoices,SalesEngine::Invoice.all
  end

  def test_random_method_works
    alpha = SalesEngine::Invoice.random
    bravo = SalesEngine::Invoice.random
    refute_equal alpha,bravo
  end

  def test_all_successful
    refute_equal SalesEngine::Invoice.all,SalesEngine::Invoice.all_successful
    refute_equal SalesEngine::Invoice.all_pending,SalesEngine::Invoice.all_successful
  end

  def test_find_by_id
    invoice = SalesEngine::Invoice.find_by_id(1)
    assert_equal invoice.customer_id,1
    refute_equal invoice.customer_id,2
  end

  def test_find_by_merchant_id
    invoice = SalesEngine::Invoice.find_by_merchant_id(75)
    assert_equal invoice.id,2    
  end

  def test_find_by_status
    invoice = SalesEngine::Invoice.find_by_status("shipped")
    assert_equal invoice.id,1
  end

  def test_find_all_by_id
    invoice = SalesEngine::Invoice.find_all_by_id(100000000)
    assert_equal invoice,[]
    SalesEngine::Invoice.find_all_by_id(3).each do |i|
      assert_equal i.id,3
      refute_equal i.id,4
    end
  end

  def test_find_all_by_customer_id
    invoice = SalesEngine::Invoice.find_all_by_customer_id(10000000000)
    assert_equal invoice,[]
    invoices = SalesEngine::Invoice.find_all_by_customer_id(3)
    assert_equal invoices.count,4
    refute_equal invoices.count,9
  end

  def test_find_all_by_merchant_id
    invoice = SalesEngine::Invoice.find_all_by_merchant_id(0000000000)
    assert_equal invoice,[]
    assert_equal SalesEngine::Merchant.count, 100
    merchant = SalesEngine::Merchant.find_by_id(26)
    assert_equal SalesEngine::Merchant.find_by_id(26).id,26
    SalesEngine::Invoice.find_all_by_merchant_id(26).each do |i|
      assert_equal merchant.id,i.merchant_id
    end
  end

  def test_find_all_by_status
    invoice = SalesEngine::Invoice.find_all_by_status("FooBar")
    assert_equal invoice,[]
    SalesEngine::Invoice.find_all_by_status("shipped").each do |i|
      assert_equal "shipped",i.status
      refute_equal "shiznipped",i.status
    end
  end

  def test_transactions_method
    invoice = SalesEngine::Invoice.find_by_id(1)
    trans = invoice.transactions
    assert_kind_of Array,trans
    assert_equal 1,trans.first.invoice_id
  end

  def test_invoice_items_method
    invoice = SalesEngine::Invoice.find_by_id(1)
    list_of_invoice_items = invoice.invoice_items
    assert_kind_of Array,list_of_invoice_items
    assert_equal 1,list_of_invoice_items.first.invoice_id
  end

  def test_items_method
    invoice = SalesEngine::Invoice.find_by_id(1)
    collection_of_associated_items = invoice.items
    assert_kind_of Array,collection_of_associated_items
    assert_equal 539,collection_of_associated_items.first.id
  end

  def test_customer_method
    invoice = SalesEngine::Invoice.find_by_id(4)
    associated_customer = invoice.customer
    assert_kind_of SalesEngine::Customer,associated_customer
    assert_equal "Joey",associated_customer.first_name
  end

  def test_create_new_invoice
    customer = SalesEngine::Customer.find_by_id(7)
    merchant = SalesEngine::Merchant.find_by_id(22)
    items = (1..3).map { SalesEngine::Item.random }

    invoice = SalesEngine::Invoice.create(customer: customer, merchant: merchant, items: items)
    assert_equal customer.id,invoice.customer_id
    invoice.charge(credit_card_number: "4444333322221111",
               credit_card_expiration: "10/13", 
               result: "success")
  end

end
