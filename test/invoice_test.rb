require_relative 'test_helper.rb'
require_relative '../lib/objects/invoice'
require_relative '../lib/sales_engine.rb'

class InvoiceTest < Minitest::Test

  def setup
    @example_record1 =  {
      :customer_id => '230',
      :merchant_id => '5603',
      :status => "shipped",
      :created_at => "sometime",
      :updated_at => "someothertime"
    }
    @se = SalesEngine.new
    @se.startup
  end

  def test_it_has_a_customer_id_accessor
    @invoice = Invoice.new(@example_record1)
    assert @invoice.respond_to?(:customer_id)
  end

  def test_it_has_a_merchant_id_accessor
    @invoice = Invoice.new(@example_record1)
    assert @invoice.respond_to?(:merchant_id)
  end

  def test_it_has_a_status_accessor
    @invoice = Invoice.new(@example_record1)
    assert @invoice.respond_to?(:status)
  end

  def test_it_has_a_created_at_accessor
    @invoice = Invoice.new(@example_record1)
    assert @invoice.respond_to?(:created_at)
  end

  def test_it_has_a_updated_at_accessor
    @invoice = Invoice.new(@example_record1)
    assert @invoice.respond_to?(:updated_at)
  end

  def test_it_does_NOT_have_an_accessor_it_should_not
    @invoice = Invoice.new(@example_record1)
    refute @invoice.respond_to?(:first_name)
  end


  def test_it_retrieves_its_transactions
    invoice = @se.invoice_repository.find_by_id("29")
    trans = invoice.transactions

    assert trans.all?{|x| x.is_a?(Transaction)}
    assert trans.all?{|x| x.invoice_id == 29}
  end

  def test_it_retrieves_different_transactions
    invoice = @se.invoice_repository.find_by_id("15")
    trans = invoice.transactions

    assert trans.all?{|x| x.is_a?(Transaction)}
    assert trans.all?{|x| x.invoice_id == 15}
  end

  def test_it_retrieves_its_invoice_items
    invoice = @se.invoice_repository.find_by_id("29")
    iis = invoice.invoice_items

    assert iis.all?{|x| x.is_a?(InvoiceItem)}
    assert iis.all?{|x| x.invoice_id == 29}
  end

  def test_it_retrieves_different_invoice_items
    invoice = @se.invoice_repository.find_by_id("15")
    iis = invoice.invoice_items

    assert iis.all?{|x| x.is_a?(InvoiceItem)}
    assert iis.all?{|x| x.invoice_id == 15}
  end

  def test_it_retrieves_items_for_its_invoice_items
    invoice = @se.invoice_repository.find_by_id("1")
    items = invoice.items
    ids = items.reduce([]){|acc, item| acc << item.id}

    assert_includes(ids, 539, "Missing item 539")
  end

  def test_it_retrieves_customer_associated_with_invoice
    invoice = @se.invoice_repository.find_by_id("1")
    cust = invoice.customer

    assert_kind_of(Customer, cust, "Did not retrieve a Customer as expected")
    assert_equal cust.id, 1
  end

  def test_it_retrieves_different_customer_with_invoice
    invoice = @se.invoice_repository.find_by_id("14")
    cust = invoice.customer

    assert_kind_of(Customer, cust, "Did not retrieve a Customer as expected")
    assert_equal cust.id, 4
  end

  def test_it_retrieves_merchant_associated_with_invoice
    invoice = @se.invoice_repository.find_by_id("1")
    merch = invoice.merchant

    assert_kind_of(Merchant, merch, "Did not retrieve a Merchant as expected")
    assert_equal merch.id, 26
  end

  def test_it_retrieves_different_merchant_associated_with_invoice
    invoice = @se.invoice_repository.find_by_id("22")
    merch = invoice.merchant

    assert_kind_of(Merchant, merch, "Did not retrieve a Merchant as expected")
    assert_equal merch.id, 79
  end

  def test_it_knows_that_an_invoice_has_not_been_paid
    invoice = @se.invoice_repository.find_by_id(48)

    refute invoice.paid?
  end

  def test_it_knows_that_another_invoice_has_not_been_paid
    invoice = @se.invoice_repository.find_by_id(13)

    refute invoice.paid?
  end

  def test_it_knows_that_an_invoice_has_been_paid
    invoice = @se.invoice_repository.find_by_id(12)

    assert invoice.paid?
  end

  def test_it_knows_the_total_dollars_invoiced_for
    invoice = @se.invoice_repository.find_by_id("8")
    total = invoice.total_billed

    expected_cents = 2 * 50051 + 5 * 50051 + 2 * 35772 + 2 * 70783 + 8 * 35772 + 9 * 70783 + 7 * 70783 + 7 * 70783
    expected_dollars = BigDecimal.new(expected_cents) / 100
    expected = expected_dollars.round(2)
    actual = total

    assert_equal expected, actual
  end




end