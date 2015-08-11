require_relative 'test_helper.rb'
require_relative '../lib/repos/merchant_repository'
require_relative '../lib/sales_engine.rb'

class MerchantRepositoryTest < Minitest::Test
  def setup
    @merchant_repository = MerchantRepository.new(:path => './fixtures/')
    @se = SalesEngine.new
    @se.startup
  end

  def test_make_sure_we_can_instantiate
    assert @merchant_repository.class == MerchantRepository
  end

  def test_we_can_make_instances_of_merchant

    hash = {:name=>"Willms and Sons", :created_at=>"2012-03-27 14:53:59 UTC", :updated_at=>"2012-03-27 14:53:59 UTC"}
    merchant = @merchant_repository.create_record(hash)

    expected = "Willms and Sons"
    result = merchant.name

    assert_equal expected, result
  end

  def test_we_can_populate_merchants
    assert @merchant_repository.records.length > 20
  end

  def test_we_can_access_a_merchants_info_from_the_merchant_repo_class
    expected = "Bechtelar, Jones and Stokes"
    actual = @merchant_repository.find_by_name("Bechtelar, Jones and Stokes")

    assert_equal expected, actual.name
  end

  def test_it_knows_top_3_merchants_for_revenue
    top_3 = @se.merchant_repository.most_revenue(3)

    expected = [84, 79, 86]
    actual = top_3.map {|x| x.id}

    assert_equal expected, actual
  end

  def test_it_knows_top_five_merchants_for_items
    top_5 = @se.merchant_repository.most_items(5)

    expected = [86, 90, 26, 38, 84]
    actual = top_5.map {|merch| merch.id}

    assert_equal expected, actual
  end

  def test_it_knows_revenue_by_date_across_merchants
    date = Date.parse("2012-03-07")
    merchants = [27,41,44,53].map {|id| @se.merchant_repository.find_by_id(id)}

    expected = merchants.inject(0){|acc, merch| acc + merch.revenue(date)}
    actual = @se.merchant_repository.revenue(date)

    assert_equal expected, actual
  end

  def test_it_knows_revenue_by_date_across_merchants_for_different_date
    merch_1 = @se.merchant_repository.find_by_id(86)
    date = Date.parse("2012-03-27")

    expected = merch_1.revenue(date)
    actual = @se.merchant_repository.revenue(Date.parse("2012-03-27"))

    assert_equal expected, actual
  end

  def test_it_creates_and_can_populate_a_table
    engine = SalesEngine.new
    engine.startup
    repo = engine.merchant_repository
    db = engine.sql_db
    repo.create_table
    db.execute "INSERT INTO merchants(id, name) VALUES (1, 'Johnny');"
    result = db.execute "SELECT * FROM merchants;"

    assert_equal 'Johnny', result.first['name']
  end

  def test_it_loads_the_data_into_the_sql_table
    engine = SalesEngine.new
    engine.startup
    repo = engine.merchant_repository
    db = engine.sql_db
    repo.create_table
    repo.populate_table
    result = db.execute "SELECT * FROM merchants;"

    assert_equal 28, result.size
    assert_equal 'Fahey-Stiedemann', result.last['name']
  end

end
