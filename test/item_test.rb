require './test/test_helper'
require 'minitest/autorun'

class ItemTest < MiniTest::Unit::TestCase

  def test_it_exists
    item = SalesEngine::Item.new(2,"name","description",2345,3)
    assert_kind_of SalesEngine::Item, item
  end

  def test_load_method_works
    assert_equal 2483, SalesEngine::Item.count
  end

  def test_random_method_works
    alpha = SalesEngine::Item.random
    bravo = SalesEngine::Item.random
    refute_equal alpha,bravo
  end
  
  def test_find_by_id
    item = SalesEngine::Item.find_by_id(1)
    assert_equal item.name,("Item Qui Esse")
  end

  def test_find_by_name
    item = SalesEngine::Item.find_by_name("Item Qui Esse")
    assert_equal item.id,(1)
  end

  def test_find_by_description
    item = SalesEngine::Item.find_by_description("Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.")
    assert_equal 1,item.id
    refute_equal 2,item.id
  end

  def test_find_by_merchant_id
    item = SalesEngine::Item.find_by_merchant_id(0000000)
    assert_equal item,nil 
    new_item = SalesEngine::Item.find_by_merchant_id(1)
    assert_equal 1,new_item.merchant_id
  end

  def test_find_by_unit_price
    skip
    item = SalesEngine::Item.find_by_unit_price(32301)
    assert_equal item.id,(3)
  end

  def test_find_all_by_name
    item = SalesEngine::Item.find_all_by_name("snarf")
    assert_equal item,[]
    SalesEngine::Item.find_all_by_name("Item Qui Esse").each do |i|
      assert_equal i.id,1
      refute_equal i.name,"Snargle"
    end
  end

  def test_find_all_by_description
    item = SalesEngine::Item.find_all_by_description("snarfsnarf")
    assert_equal item,[]
    SalesEngine::Item.find_all_by_description("Cumque consequuntur ad. Fuga tenetur illo molestias enim aut iste.
    Provident quo hic aut. Aut quidem voluptates dolores. Dolorem quae ab alias tempora.").each do |i|
      assert_equal 2,i.id
      assert_equal "Item Autem Minima",i.name
      refute_equal 3,i.id
    end
  end

  def test_find_all_by_unit_price
    item = SalesEngine::Item.find_all_by_unit_price(00000)
    assert_equal item,[]
    SalesEngine::Item.find_all_by_unit_price(75107).each do |i|
      assert_equal 75107,i.unit_price
      refute_equal 2,i.id
    end
  end

  def test_find_all_by_merchant_id
    item = SalesEngine::Item.find_all_by_merchant_id(0000000)
    assert_equal item,[]
    refute_equal item,[""]

    SalesEngine::Item.find_all_by_merchant_id(1).each do |i|
      assert_equal 1,i.merchant_id 
      assert_equal SalesEngine::Merchant.find_by_id(1).id,i.merchant_id
    end
  end

  def test_invoice_items_method
    item = SalesEngine::Item.find_by_id(2)
    collection_of_invoice_items = item.invoice_items
    assert_kind_of Array,collection_of_invoice_items
    assert_kind_of SalesEngine::InvoiceItem,collection_of_invoice_items.first
    assert_kind_of SalesEngine::Item,item
    assert_equal 2,collection_of_invoice_items.first.item_id
    collection_of_invoice_items.each do |c|
      assert_equal 2,c.item_id
      assert_kind_of SalesEngine::InvoiceItem,c
    end
  end

  def test_merchant_method
    item = SalesEngine::Item.find_by_id(5)
    merchant_instance = item.merchant
    assert_kind_of SalesEngine::Merchant,merchant_instance
    assert_kind_of SalesEngine::Item,item
    assert_equal "Schroeder-Jerde",merchant_instance.name
  end

  def test_most_revenue
    most = SalesEngine::Item.most_revenue(5)
    assert_equal 5,most.count
    assert_equal "Item Dicta Autem", most.first.name
    assert_equal "Item Amet Accusamus", most.last.name
  end

  def test_most_items
    most = SalesEngine::Item.most_items(37)
    assert_equal "Item Nam Magnam", most[1].name
    assert_equal "Item Ut Quaerat", most.last.name
    assert_equal 37, most.count
  end

  def test_best_day
    item = SalesEngine::Item.find_by_name "Item Accusamus Ut"
    date = Date.parse "Sat, 24 Mar 2012"
    assert_equal date,item.best_day.to_date
  end
end
