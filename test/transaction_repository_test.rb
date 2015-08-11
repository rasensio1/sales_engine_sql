require_relative 'test_helper.rb'
require_relative '../lib/repos/transaction_repository'
require_relative '../lib/sales_engine.rb'

class TransactionRepositoryTest < Minitest::Test

  def setup
    @transaction_repository = TransactionRepository.new(:path => './fixtures/')
    @se = SalesEngine.new
    @se.startup
  end
  def test_make_sure_we_can_instantiate
    assert @transaction_repository.class == TransactionRepository
  end
  def test_we_can_make_instances_of_Transaction

    transaction_record = {:invoice_id => '23034',
                        :credit_card_number => '892384923',
                        :credit_card_expiration_date => "9283",
                        :result => "good",
                        :created_at => "sometime",
                        :updated_at => "someothertime"}
    transaction = @transaction_repository.create_record(transaction_record)

    expected = "someothertime"
    result = transaction.updated_at

    assert_equal expected,  result
  end
  def test_we_can_populate_transactions
    assert @transaction_repository.records.length > 20
  end

  def test_it_knows_the_number_of_successful_transactions
    expected = 32
    actual = @se.transaction_repository.count

    assert_equal expected, actual
  end

  def test_it_creates_and_can_populate_a_table
    engine = SalesEngine.new
    engine.startup
    repo = engine.transaction_repository
    db = engine.sql_db
    repo.create_table
    db.execute "INSERT INTO transactions(id, invoice_id, credit_card_number)
                  VALUES (1, 2, 1234123412341234);"
    result = db.execute "SELECT * FROM transactions;"
    assert_equal 1234123412341234, result.first['credit_card_number']
  end

  def test_it_loads_the_data_into_the_sql_table
    engine = SalesEngine.new
    engine.startup
    repo = engine.transaction_repository
    db = engine.sql_db
    repo.create_table
    repo.populate_table
    result = db.execute "SELECT * FROM transactions;"

    assert_equal 38, result.size
    assert_equal 4777856041170635, result[31]['credit_card_number']
  end

end
