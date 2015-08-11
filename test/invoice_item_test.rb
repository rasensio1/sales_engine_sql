require_relative 'test_helper.rb'
require_relative '../lib/objects/invoice_item'
require_relative '../lib/sales_engine.rb'

class InvoiceItemTest < Minitest::Test


  def setup
    @example_record1 =  {
      :item_id => '2310',
      :invoice_id => '5603',
      :quantity => "2",
      :unit_price => "12412",
      :created_at => "sometime",
      :updated_at => "someothertime"
    }
    @se = SalesEngine.new
    @se.startup
  end

  def test_it_has_a_item_id_accessor
    @invoice_item = InvoiceItem.new(@example_record1)
    assert @invoice_item.respond_to?(:item_id)
  end

  def test_it_has_a_invoice_id_accessor
    @invoice_item = InvoiceItem.new(@example_record1)
    assert @invoice_item.respond_to?(:invoice_id)
  end

  def test_it_has_a_quantity_accessor
    @invoice_item = InvoiceItem.new(@example_record1)
    assert @invoice_item.respond_to?(:quantity)
  end

  def test_it_has_a_unit_price_accessor
    @invoice_item = InvoiceItem.new(@example_record1)
    assert @invoice_item.respond_to?(:unit_price)
  end

  def test_it_has_a_created_at_accessor
    @invoice_item = InvoiceItem.new(@example_record1)
    assert @invoice_item.respond_to?(:created_at)
  end

  def test_it_has_a_updated_at_accessor
    @invoice_item = InvoiceItem.new(@example_record1)
    assert @invoice_item.respond_to?(:updated_at)
  end

  def test_it_does_NOT_have_an_accessor_it_should_not
    @invoice_item = InvoiceItem.new(@example_record1)
    refute @invoice_item.respond_to?(:first_name)
  end


  def test_it_retrieves_invoice_for_invoice_item
    ii = @se.invoice_item_repository.find_by_id("1")
    invoice = ii.invoice

    assert_kind_of(Invoice, invoice, "Didn't retrieve an Invoice as expected")
    assert_equal invoice.id, 1
  end

  def test_it_retrieves_invoice_for_another_invoice_item
    ii = @se.invoice_item_repository.find_by_id("13")
    invoice = ii.invoice

    assert_kind_of(Invoice, invoice, "Didn't retrieve an Invoice as expected")
    assert_equal invoice.id, 3
  end

  def test_it_retrieves_item_for_invoice_item
    ii = @se.invoice_item_repository.find_by_id("17")
    item = ii.item

    assert_kind_of(Item, item, "Didn't retrieve an Item as expected")
    assert_equal item.id, 1922
  end

  def test_it_retrieves_item_for_another_invoice_item
    ii = @se.invoice_item_repository.find_by_id("44")
    item = ii.item

    assert_kind_of(Item, item, "Didn't retrieve an Item as expected")
    assert_equal item.id, 847
  end

  def test_it_knows_total_price
    ii = @se.invoice_item_repository.find_by_id("44")

    expected = BigDecimal.new(7 * 70783) / 100
    actual = ii.total_price

    assert_equal expected, actual
  end


end