require './test/test_helper'
require 'date'

class MerchantTest < MiniTest::Unit::TestCase

  def test_it_exists
    merchant = SalesEngine::Merchant.new(1,"Merchant Name")
    assert_kind_of SalesEngine::Merchant, merchant
  end

  def test_load_method_works
    assert_equal 100, SalesEngine::Merchant.count
  end

  def test_random_method_works
    alpha = SalesEngine::Merchant.random
    bravo = SalesEngine::Merchant.random
    refute_equal alpha,bravo
  end

  def test_find_by_id
    merchants = SalesEngine::Merchant.find_by_id(1)
    assert_equal merchants.name,"Schroeder-Jerde"
  end

  def test_find_by_name
    merchants = SalesEngine::Merchant.find_by_name("Hand-Spencer")
    assert_equal merchants.id,9
  end

  def test_find_all_by_id_method
    merchants = SalesEngine::Merchant.find_all_by_id(999)
    assert_equal merchants,[]
    merchant = SalesEngine::Merchant.find_all_by_id(4).each do |m|
      assert_equal m.name,"Cummings-Thiel"
      refute_equal m.name,"Zebulon, INC"
    end
  end

  def test_find_all_by_name_method
    merchants = SalesEngine::Merchant.find_all_by_name("ZEBULON, INC")
    assert_equal merchants,[]
    SalesEngine::Merchant.find_all_by_name("Schuppe, Friesen and Schmeler").each do |m|
      assert_equal m.id,39
      refute_equal m.id,40
    end
  end

  def test_items_method
    merchant = SalesEngine::Merchant.find_by_id(1)
    merchant.items.each do |i|
      assert_equal 1,i.merchant_id
    end
  end

  def test_invoices_method
    merchant = SalesEngine::Merchant.find_by_id(2)
    assert_equal merchant.invoices.first.merchant_id,SalesEngine::Invoice.find_all_by_merchant_id(merchant.id).first.merchant_id
    assert_equal merchant.invoices.last.merchant_id,SalesEngine::Invoice.find_all_by_merchant_id(merchant.id).last.merchant_id
  end

  def test_most_revenue_method
    list = SalesEngine::Merchant.most_revenue(3)
    assert_equal 3,list.length
    assert_equal 'Dicki-Bednar',list.first.name
    assert_equal "Okuneva, Prohaska and Rolfson",list.last.name
  end

  def test_most_items
    most_items = SalesEngine::Merchant.most_items(5)
    assert_kind_of Array, most_items
    refute_equal nil, most_items.first.name
    assert_equal "Kassulke, O'Hara and Quitzon", most_items.first.name
    assert_equal "Daugherty Group", most_items.last.name
  end

  def test_self_revenue_method
     # it "returns all revenue for a given date"
    date = "Tue, 20 Mar 2012"
    revenue = SalesEngine::Merchant.revenue(date)
    assert_equal BigDecimal.new("2549722.91"),revenue
  end

  def test_revenue
    merchant = SalesEngine::Merchant.find_by_name "Dicki-Bednar" 
    # it "reports all revenue" do
    assert_equal BigDecimal.new("1148393.74"),merchant.revenue
    # it "restricts to that date" do
    new_merchant = SalesEngine::Merchant.find_by_name "Willms and Sons"
    date = "Fri, 09 Mar 2012"
    assert_equal BigDecimal.new("8373.29"),new_merchant.revenue(date)
  end

  def test_favorite_customer
    merchant = SalesEngine::Merchant.find_by_name "Terry-Moore"
    customer_names = [["Jayme", "Hammes"], ["Elmer", "Konopelski"], ["Eleanora", "Kling"],
                    ["Friedrich", "Rowe"], ["Orion", "Hills"], ["Lambert", "Abernathy"]]
    customer = merchant.favorite_customer
    assert_equal "Hammes",customer.last_name
    assert_equal "Jayme",customer.first_name
  end

  def test_customers_with_pending_invoices
    merchant = SalesEngine::Merchant.find_by_name "Parisian Group"
    # it "returns the total number of customers with pending invoices" do
    customers = merchant.customers_with_pending_invoices
    assert_equal 4,customers.count
    assert_equal true, customers.collect {|i|i.last_name}.include?("Ledner")
  end
end
