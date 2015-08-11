require_relative 'test_helper.rb'
require_relative '../lib/sales_engine'

class SalesEngineTest < Minitest::Test


  def setup
    @engine = SalesEngine.new
  end

  def test_we_can_start_our_engine
    assert @engine.startup
  end

  def test_can_create_an_sql_databse
    assert_kind_of SQLite3::Database, @engine.sql_db
  end

  def test_our_engine_responds_to_merchant_repository
    @engine.startup
    assert @engine.merchant_repository
  end

  def test_our_engine_has_a_merchant_repository_class
    @engine.startup
    assert_equal MerchantRepository, @engine.merchant_repository.class
  end

end
