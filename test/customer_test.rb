require './test/test_helper'

class CustomerTest < MiniTest::Unit::TestCase

  def test_it_exists
    customer = SalesEngine::Customer.new(2, "Mike", "Johnson")
    assert_kind_of SalesEngine::Customer, customer
  end

  def test_load_method_works
    assert_equal 1000, SalesEngine::Customer.count
  end

  def test_random_method_works
    alpha = SalesEngine::Customer.random
    bravo = SalesEngine::Customer.random
    refute_equal alpha,bravo
  end

  def test_find_by_id
    customer = SalesEngine::Customer.find_by_id(1)
    assert_equal customer.first_name,"Joey"
    customer = SalesEngine::Customer.find_by_id(21)
    assert_equal customer.first_name,"Felipe"
  end

  def test_find_by_first_name
    customer = SalesEngine::Customer.find_by_first_name("Mary")
    assert_equal customer.first_name,"Mary"
    refute_equal customer.first_name,"Mary Ellen"
  end

  def test_find_by_last_name
    customer = SalesEngine::Customer.find_by_last_name("Smith")
    assert_equal customer.last_name,"Smith"
  end

  def test_find_all_by_last_name
    customer = SalesEngine::Customer.find_all_by_last_name("LKJLKJLKJL")
    assert_equal customer,[]
    new_customer = SalesEngine::Customer.find_all_by_last_name("Smith")
    assert_equal "Smith",new_customer.first.last_name
    assert_equal "Smith",new_customer.last.last_name
  end

  def test_find_all_by_first_name
    customer = SalesEngine::Customer.find_all_by_first_name("LKAJLKJSLKDJSLKDJ")
    assert_equal customer,[]
    new_customer = SalesEngine::Customer.find_all_by_first_name("Katrina")
    assert_equal "Katrina",new_customer.first.first_name
    assert_equal "Katrina",new_customer.last.first_name
    assert_equal "Hegmann",new_customer.first.last_name
  end

  def test_invoices
    customer = SalesEngine::Customer.find_by_id(1)
    assert_equal customer.invoices.first, SalesEngine::Invoice.find_by_customer_id(1)
  end

  def test_transactions
    customer =  SalesEngine::Customer.find_by_id 2
    assert_equal 1,customer.transactions.count
  end

  def test_favorite_merchant
    customer =  SalesEngine::Customer.find_by_id 2
    assert_equal "Shields, Hirthe and Smith",customer.favorite_merchant.name
  end

  
end
