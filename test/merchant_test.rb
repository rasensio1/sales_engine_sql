require 'bigdecimal'
require_relative 'test_helper.rb'
require_relative '../lib/objects/merchant'
require_relative '../lib/sales_engine.rb'

class MerchantTest < Minitest::Test
  
  
  def setup
    @example_record1 =  {:id => '1',
                        :name => 'Matt',
                        :created_at => "sometime",
                        :updated_at => "someothertime"}
    @se = SalesEngine.new
    @se.startup
  end

  def test_it_has_a_name_accessor
    @merchant = Merchant.new(@example_record1)
    assert @merchant.respond_to?(:name)
  end

  def test_it_has_a_created_at_accessor
    @merchant = Merchant.new(@example_record1)
    assert @merchant.respond_to?(:created_at)
  end

  def test_it_has_a_updated_at_accessor
    @merchant = Merchant.new(@example_record1)
    assert @merchant.respond_to?(:updated_at)
  end

  def test_it_does_NOT_have_an_accessor_it_shouldnt
    @merchant = Merchant.new(@example_record1)
    refute @merchant.respond_to?(:description)
  end

  def test_it_retrieves_invoices
    merchant = @se.merchant_repository.find_by_id("8")
    invoices = merchant.invoices

    assert invoices.all?{|element| element.is_a?(Invoice)}
    assert invoices.all?{|element| element.merchant_id == 8}
  end

  def test_it_retrieves_other_invoices
    merchant = @se.merchant_repository.find_by_id("99")
    invoices = merchant.invoices

    assert invoices.all?{|element| element.is_a?(Invoice)}
    assert invoices.all?{|element| element.merchant_id == 99}
  end

  def test_it_retrieves_its_items
    merchant = @se.merchant_repository.find_by_id("14")
    items = merchant.items

    assert items.all?{|item| item.is_a?(Item)}
    assert items.all?{|item| item.merchant_id == 14}
  end

  def test_it_retrieves_different_items
    merchant = @se.merchant_repository.find_by_id("76")
    items = merchant.items

    assert items.all?{|item| item.is_a?(Item)}
    assert items.all?{|item| item.merchant_id == 76}
  end

  def test_it_retrieves_invoice_items
    merchant = @se.merchant_repository.find_by_id("8")
    invoices = merchant.invoices
    iis = merchant.invoice_items(invoices)
    iis_ids = iis.map{|element| element.id}

    assert iis.all?{|element| element.is_a?(InvoiceItem)}, "Not all are InvoiceItems"
    assert iis.all?{|element| element.invoice_id == 12}, "Not finding invoice number 12"
    assert_includes(iis_ids, 60, "60 isn't in invoice_item ids")
  end

  def test_it_knows_its_total_revenue
    merchant = @se.merchant_repository.find_by_id("8")
    rev = merchant.revenue

    expected_cents = 2*78031 + 2*41702 + 6*71340 + 6*7196 + 3*41702 + 8*22546
    expected_dollars = BigDecimal.new(expected_cents) / 100
    expected = expected_dollars.round(2)
    actual = rev

    assert_equal expected, actual
  end

  def test_it_knows_revenue_for_given_date
    date = Date.parse("2012-03-21")
    merchant = @se.merchant_repository.find_by_id("8")

    expected = merchant.revenue
    actual = merchant.revenue(date)

    assert_equal expected, actual
  end

  def test_it_returns_zero_revenue_for_merchant_with_all_failed_transactions
    merchant = @se.merchant_repository.find_by_id("56")
    rev = merchant.revenue

    assert_equal 0, rev
  end

  def test_returns_zero_if_no_revenue_is_found_for_given_date
    date = Date.parse("2012-03-27")
    merchant = @se.merchant_repository.find_by_id("8")

    expected = BigDecimal.new(0)
    actual = merchant.revenue(date)

    assert_equal expected, actual
  end

  def test_it_has_collection_of_unpaid_invoices
    merchant = @se.merchant_repository.find_by_id(34)

    expected = [13]
    actual = merchant.unpaid_invoices.map{|invoice| invoice.id}

    assert_equal expected, actual
  end

  def test_it_returns_empty_array_if_all_invoices_paid
    merchant = @se.merchant_repository.find_by_id(1)

    expected = []
    actual = merchant.unpaid_invoices

    assert_equal expected, actual
  end

  def test_it_has_collection_of_customers_with_unpaid_invoices
    merchant = @se.merchant_repository.find_by_id(34)

    expected = [3]
    actual = merchant.customers_with_pending_invoices.map{|cust| cust.id}

    assert_equal expected, actual
  end

  def test_it_has_a_favorite_customer_based_on_successful_transactions
    merchant = @se.merchant_repository.find_by_id(1)

    expected = 7
    actual = merchant.favorite_customer.id

    assert_equal expected, actual
  end



end