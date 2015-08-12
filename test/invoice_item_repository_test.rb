require_relative 'test_helper.rb'
require_relative '../lib/repos/invoice_item_repository'
require_relative '../lib/sales_engine.rb'

class InvoiceItemRepositoryTest < Minitest::Test

  def setup
    @se = SalesEngine.new
    @se.startup
    @invoice_item_repository = @se.invoice_item_repository
  end
  def test_make_sure_we_can_instantiate
    assert @invoice_item_repository.class == InvoiceItemRepository
  end
  def test_we_can_make_instances_of_Invoice_Item

    invoice_item_record = {'item_id' => '2310',
                         'invoice_id' => '5603',
                         'quantity' => "2",
                         'unit_price' => "12412",
                        'created_at' => "sometime",
                        'updated_at' => "someothertime"}
    invoice_item = @invoice_item_repository.create_record(invoice_item_record)

    expected = BigDecimal.new("124.12")
    result = invoice_item.unit_price

    assert_equal expected,  result
  end

  def test_we_can_populate_invoices
    assert @invoice_item_repository.records.length > 20
  end

  def test_it_loads_the_data_into_the_sql_table
    engine = @se
    repo = engine.invoice_item_repository
    db = engine.sql_db

    result = db.execute "SELECT * FROM invoice_items;"

    assert_equal 143, result.size
  end

end
