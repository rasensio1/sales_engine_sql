require_relative 'test_helper.rb'
require_relative '../lib/repos/transaction_repository'
require_relative '../lib/sales_engine.rb'

class TransactionRepositoryTest < Minitest::Test

  def setup
    @se = SalesEngine.new
    @se.startup
    @transaction_repository = @se.transaction_repository
  end
  def test_make_sure_we_can_instantiate
    assert @transaction_repository.class == TransactionRepository
  end

  def test_we_can_populate_transactions
    assert @transaction_repository.records.length > 20
  end

  def test_it_knows_the_number_of_successful_transactions
    expected = 32
    actual = @se.transaction_repository.count

    assert_equal expected, actual
  end


  def test_it_loads_the_data_into_the_sql_table
    repo = @se.transaction_repository
    db = @se.sql_db
    result = db.execute "SELECT * FROM transactions;"

    assert_equal 38, result.size
    assert_equal 4777856041170635, result[31]['credit_card_number']
  end

  def test_it_creates_transactions_from_the_sql_table
    repo = @transaction_repository
    db = @se.sql_db
    result = db.execute "SELECT * FROM transactions;"

    assert_equal 38, result.size
    assert_equal 4777856041170635, repo.records[31].credit_card_number
  end

  def test_can_find_all
    result = @transaction_repository.all

    assert_equal 38, result.size
    assert_kind_of Transaction, result.first
  end

  def test_it_can_find_by
    result = @transaction_repository.find_by('id', 3)
    assert_equal 4, result.invoice_id
  end

end
