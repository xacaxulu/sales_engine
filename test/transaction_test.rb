require './test/test_helper'

module SalesEngine
  class TransactionTest < MiniTest::Unit::TestCase
    
    def test_it_exists
      transaction = SalesEngine::Transaction.new(2,3,3333444455556666,0,"success")
      assert_kind_of SalesEngine::Transaction, transaction
    end

    def test_load_method_works
      assert_equal 5596, SalesEngine::Transaction.count
    end

    def test_all_method
      transaction = SalesEngine::Transaction.all
      assert_kind_of Array, transaction
      assert_equal 5596, transaction.count
    end

    def test_all_successful
      successful_transaction = SalesEngine::Transaction.all_successful
      assert_kind_of Array,successful_transaction
      refute_equal [],successful_transaction
      refute_equal nil,successful_transaction
      refute_equal SalesEngine::Transaction.all,successful_transaction
      refute_equal 5596, successful_transaction.count
      assert_equal 4648, successful_transaction.count
    end

    def test_all_successful_invoice_ids
      ids_list = SalesEngine::Transaction.all_successful_invoice_ids
      assert_kind_of Array,ids_list
      assert_equal 4648,ids_list.count
    end
    def test_random_method_works
      alpha = SalesEngine::Transaction.random
      bravo = SalesEngine::Transaction.random
      refute_equal alpha,bravo
    end

    def test_find_by_id
      transaction = SalesEngine::Transaction.find_by_id(2)
      assert_equal transaction.invoice_id,2
    end

    def test_find_by_invoice_id
      transaction = SalesEngine::Transaction.find_by_invoice_id(1)
      assert_equal transaction.id,1
    end

    def test_find_by_credit_card_number
      transaction = SalesEngine::Transaction.find_by_credit_card_number(4654405418249632)
      assert_equal transaction.id,1
    end

    def test_find_by_result
      transaction = SalesEngine::Transaction.find_by_result("success")
      assert_equal transaction.id,1
    end

    def test_find_all_by_invoice_id
      transaction = SalesEngine::Transaction.find_all_by_invoice_id(1)
      assert_kind_of Array,transaction
      assert_equal 1,transaction.first.invoice_id
      assert_equal 1,transaction.last.invoice_id
    end

    def test_invoice
      transaction = SalesEngine::Transaction.find_by_id(1)
      invoice = transaction.invoice
      assert_kind_of SalesEngine::Transaction,transaction
      assert_kind_of SalesEngine::Invoice,invoice
      assert_equal 26,invoice.merchant_id
    end

  end
end
