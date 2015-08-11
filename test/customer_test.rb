require_relative 'test_helper.rb'
require_relative '../lib/objects/customer'
require_relative '../lib/sales_engine.rb'

class CustomerTest < Minitest::Test


  def setup
    @example_record1 =  {
      :first_name => 'george',
      :last_name => 'timothy',
      :created_at => "sometime",
      :updated_at => "someothertime"
    }
    @se = SalesEngine.new
    @se.startup
  end

  def test_it_has_a_first_name_accessor
    @customer = Customer.new(@example_record1)
    assert @customer.respond_to?(:first_name)
  end

  def test_it_has_a_last_name_accessor
    @customer = Customer.new(@example_record1)
    assert @customer.respond_to?(:last_name)
  end

  def test_it_has_a_created_at_accessor
    @customer = Customer.new(@example_record1)
    assert @customer.respond_to?(:created_at)
  end

  def test_it_has_a_updated_at_accessor
    @customer = Customer.new(@example_record1)
    assert @customer.respond_to?(:updated_at)
  end

  def test_it_finds_invoices_for_itself
    cust = @se.customer_repository.find_by_id(1)
    invoices = cust.invoices
    invoice_ids = invoices.map{|x| x.id}.sort

    assert_equal (1..8).to_a, invoice_ids
  end

  def test_it_finds_other_invoices_for_itself
    cust = @se.customer_repository.find_by_id(2)
    invoices = cust.invoices
    invoice_ids = invoices.map{|x| x.id}.sort

    assert_equal [9], invoice_ids
  end

  def test_it_finds_transactions
    cust = @se.customer_repository.find_by_id(2)
    transactions = cust.transactions

    expected = [8]
    actual = transactions.map {|trans| trans.id}

    assert_equal expected, actual
  end

  def test_it_finds_other_transactions
    cust = @se.customer_repository.find_by_id(1)
    transactions = cust.transactions

    expected = [1,2,3,4,5,6,7]
    actual = transactions.map {|trans| trans.id}

    assert_equal expected, actual
  end

  def test_it_has_a_favorite_merchant 
    #most number successful transactions for a merchant
    cust = @se.customer_repository.find_by_id(7777777)

    expected = 63
    actual = cust.favorite_merchant.id

    assert_equal expected, actual
  end

  def test_it_knows_days_since_last_transaction
    cust = @se.customer_repository.find_by_id(1)

    expected = (DateTime.now - DateTime.parse("2012-03-27T14:54:10+00:00")).to_i
    actual = cust.days_since_activity

    assert_equal expected, actual
  end

  def test_it_knows_different_days_since_last_transaction
    cust = @se.customer_repository.find_by_id(7777777)

    expected = (DateTime.now - DateTime.parse("2012-03-25T13:54:11+00:00")).to_i
    actual = cust.days_since_activity

    assert_equal expected, actual
  end

  def test_it_knows_its_paid_invoice_items
    cust = @se.customer_repository.find_by_id(1)
    iis = cust.paid_invoice_items

    search = @se.invoice_item_repository.find_by_id(12)

    assert_equal 37, iis.length
    assert_includes(iis, search)
  end

  def test_it_knows_how_many_items_it_has_paid_for
    cust = @se.customer_repository.find_by_id(1)
    qty = cust.paid_item_quantity

    assert_equal 186, qty
  end

  def test_it_knows_how_much_revenue_it_has_generated
    cust = @se.customer_repository.find_by_id(1)

    expected = BigDecimal.new("9072270") / 100
    actual = cust.revenue

    assert_equal expected, actual
  end
end