require './test/test_helper'

class InvoiceItemTest < MiniTest::Unit::TestCase

  def test_it_exists
    
    invoice_item = SalesEngine::InvoiceItem.new(1,2,3,12,12344)
    assert_kind_of SalesEngine::InvoiceItem, invoice_item
  end

  def test_load_method_works
    
    assert_equal 21687, SalesEngine::InvoiceItem.count
  end

  def test_random_method_works
    
    alpha = SalesEngine::InvoiceItem.random
    bravo = SalesEngine::InvoiceItem.random
    refute_equal alpha,bravo
  end

  def test_find_by_id
    
    invoice_item = SalesEngine::InvoiceItem.find_by_id(1)
    assert_equal invoice_item.unit_price,(13635)
  end

  def test_find_by_item_id
    
    invoice_item = SalesEngine::InvoiceItem.find_by_item_id(539)
    assert_equal invoice_item.unit_price,(13635)
  end

  def test_find_by_invoice_id
    
    invoice_item = SalesEngine::InvoiceItem.find_by_invoice_id(1)
    assert_equal invoice_item.unit_price,(13635)
  end

  def test_find_by_quantity
    
    invoice_item = SalesEngine::InvoiceItem.find_by_quantity(5)
    assert_equal invoice_item.unit_price,(13635)
  end

  def test_find_by_unit_price
    
    invoice_item = SalesEngine::InvoiceItem.find_by_unit_price(34873)
    assert_equal invoice_item.id,(3)
  end

  def test_find_all_by_invoice_id
    
    list_of_invoice_items_by_id = SalesEngine::InvoiceItem.find_all_by_invoice_id(1)
    assert_kind_of Array,list_of_invoice_items_by_id
    assert_equal 1,list_of_invoice_items_by_id.first.invoice_id
    assert_equal 1,list_of_invoice_items_by_id.last.invoice_id
    refute_equal 2,list_of_invoice_items_by_id.first.invoice_id
  end

  def test_find_all_by_item_id
    
    list_of_items = SalesEngine::InvoiceItem.find_all_by_item_id(528)
    assert_kind_of Array,list_of_items
    assert_equal 2,list_of_items.first.id
  end


  def test_invoice_method
    
    invoice_item = SalesEngine::InvoiceItem.find_by_id(5)
    instance_of_invoice = invoice_item.invoice
    assert_kind_of SalesEngine::InvoiceItem,invoice_item
    assert_kind_of SalesEngine::Invoice,instance_of_invoice
    assert_equal 1,instance_of_invoice.id
  end

  def test_item_method
    
    invoice_item = SalesEngine::InvoiceItem.find_by_id(10)
    instance_of_item = invoice_item.item
    assert_kind_of SalesEngine::InvoiceItem,invoice_item
    assert_kind_of SalesEngine::Item,instance_of_item
    assert_equal 1830,instance_of_item.id
  end

end
