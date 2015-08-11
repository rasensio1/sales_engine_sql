require_relative 'test_helper'
require_relative '../lib/sales_engine'

class TableLikeTest < Minitest::Test
  def setup
    @se = SalesEngine.new
    @se.startup
  end

  def test_it_finds_a_random_customer
    cust_1 = @se.customer_repository.random
    cust_2 = @se.customer_repository.random
    cust_3 = @se.customer_repository.random
    customers = [cust_1, cust_2, cust_3]

    assert customers.all?{|element| element.is_a?(Customer)}, "Missing random customers or at least one is not a Customer object"
    refute (cust_1 == cust_2) == cust_3, "Ain't random or sample too small"
  end

  def test_it_returns_all_customers
    all_customers = @se.customer_repository.all

    assert all_customers.length == @se.customer_repository.records.length, "All objects array and repository length do not match"
    assert all_customers.all?{|element| element.is_a?(Customer)}, "Not all objects in array are customers"
  end
end