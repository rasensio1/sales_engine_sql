require_relative 'test_helper.rb'
require_relative '../lib/objects/item'
require_relative '../lib/sales_engine.rb'

class ItemTest < Minitest::Test

  def setup
    @example_record1 =
    {
      :name => 'bringle pop',
      :description => 'fizzy, lizzy, bringle pop',
      :unit_price => 75107,
      :merchant_id => 250,
      :created_at => "sometime",
      :updated_at => "someothertime"
    }
    @se = SalesEngine.new
    @se.startup
  end

  def test_it_has_a_name_accessor
    @item = Item.new(@example_record1)
    assert @item.respond_to?(:name)
  end

  def test_it_has_a_description_accessor
    @item = Item.new(@example_record1)
    assert @item.respond_to?(:description)
  end

  def test_it_has_a_unit_price_accessor
    @item = Item.new(@example_record1)
    assert @item.respond_to?(:unit_price)
  end

  def test_it_has_a_merchant_id_accessor
    @item = Item.new(@example_record1)
    assert @item.respond_to?(:merchant_id)
  end

  def test_it_has_a_created_at_accessor
    @item = Item.new(@example_record1)
    assert @item.respond_to?(:created_at)
  end

  def test_it_has_a_updated_at_accessor
    @item = Item.new(@example_record1)
    assert @item.respond_to?(:updated_at)
  end

  def test_it_does_NOT_have_an_accessor_it_should_not
    @item = Item.new(@example_record1)
    refute @item.respond_to?(:first_name)
  end

  def test_it_finds_invoice_items_for_itself
    item = @se.item_repository.find_by_id("539")
    invoice_items = item.invoice_items
    invoice_item_ids = invoice_items.map {|element| element.item_id}

    assert invoice_items.all?{|element| element.is_a?(InvoiceItem)}
    assert invoice_item_ids.all?{|x| x == 539}
  end

  def test_it_finds_other_invoice_items_for_itself
    item = @se.item_repository.find_by_id("1918")
    invoice_items = item.invoice_items
    invoice_item_ids = invoice_items.map {|element| element.item_id}

    assert invoice_items.all?{|element| element.is_a?(InvoiceItem)}
    assert invoice_item_ids.all?{|x| x == 1918}
  end

  def test_it_finds_merchant_for_itself
    item = @se.item_repository.find_by_id("1")
    merchant = item.merchant

    assert_equal merchant.id, 1
  end

  def test_it_finds_other_merchant_for_itself
    item = @se.item_repository.find_by_id("292")
    merchant = item.merchant

    assert_equal merchant.id, 18
  end

  def test_it_knows_its_revenue
    item = @se.item_repository.find_by_id(1)

    expected_cents = 2 * 75107
    expected_big_cents = BigDecimal.new(expected_cents)
    expected_dollars = expected_big_cents / 100
    actual = item.revenue

    assert_equal expected_dollars, actual
  end

  def test_it_knows_a_zero_revenue
    item = @se.item_repository.find_by_id(719)

    expected = (BigDecimal.new(0)).round(2)
    actual = item.revenue

    assert_equal expected, actual
  end

  def test_knows_quantity_sold_for_completed_transactions
    item = @se.item_repository.find_by_id(539)

    expected = 5
    actual = item.quantity_sold

    assert_equal expected, actual
  end

  def test_composite_quantity
    item = @se.item_repository.find_by_id(6)

    expected = 7
    actual = item.quantity_sold

    assert_equal expected, actual
  end

  def test_it_knows_a_different_quantity_sold
    item = @se.item_repository.find_by_id(88888890)

    expected = 13
    actual = item.quantity_sold

    assert_equal expected, actual
  end

  def test_it_knows_best_day_by_most_sales
    item = @se.item_repository.find_by_id(1)
    best_day = item.best_day

    expected = Date.parse("2012-03-25")
    actual = best_day

    assert_equal expected, actual
  end

  def test_it_knows_a_different_best_day_by_most_sales
    item = @se.item_repository.find_by_id(543)
    best_day = item.best_day

    expected = Date.parse("2012-03-07")
    actual = best_day

    assert_equal expected, actual
  end


end