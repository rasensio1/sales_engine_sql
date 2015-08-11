require_relative 'test_helper.rb'
require_relative '../lib/repos/item_repository'
require_relative '../lib/sales_engine'

class ItemRepositoryTest < Minitest::Test
  
  def setup
    @item_repository = ItemRepository.new(:path => './fixtures/')
    @se = SalesEngine.new
    @se.startup
  end

  def test_make_sure_we_can_instantiate
    assert @item_repository.class == ItemRepository
  end

  def test_we_can_make_instances_of_Item
    item_record = {:name => 'bringle pop',
                        :description => 'fizzy, lizzy, bringle pop',
                        :unit_price => 75107,
                        :merchant_id => 250,
                        :created_at => "sometime",
                        :updated_at => "someothertime",}
    item = @item_repository.create_record(item_record)

    expected = BigDecimal.new("75107") / 100
    result = item.unit_price
    
    assert_equal expected,  result
  end

  def test_we_can_populate_items
    assert @item_repository.records.length > 20
  end

  def test_we_can_access_a_item_info_from_the_item_repo_class
    expected = BigDecimal.new("340.18")
    result = @item_repository.find_by_id(10).unit_price
    assert_equal expected, result
  end

  def test_it_knows_item_which_has_generated_most_revenue
    expected = 227
    actual = @se.item_repository.most_revenue(1).first.id

    assert_equal expected, actual
  end

  def test_it_knows_top_five_for_revenue
    top_5 = @se.item_repository.most_revenue(5)

    expected = [227, 847, 88888890, 88888889, 1162]
    actual = top_5.map {|item| item.id}

    assert_equal expected, actual
  end

  def test_it_knows_top_five_for_quanity_sold
    top_5 = @se.item_repository.most_items(5)

    # expected = [88888890, 88888889, 88888888, 937, 936]
    expected = [227, 847, 543, 1162, 88888890]
    actual = top_5.map {|item| item.id}

    assert_equal expected, actual
  end

end
