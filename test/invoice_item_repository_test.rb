require_relative 'test_helper.rb'
require_relative '../lib/repos/invoice_item_repository'

class InvoiceItemRepositoryTest < Minitest::Test
  
  def setup
    @invoice_item_repository = InvoiceItemRepository.new(:path => './fixtures/')
  end  
  def test_make_sure_we_can_instantiate
    assert @invoice_item_repository.class == InvoiceItemRepository
  end
  def test_we_can_make_instances_of_Invoice_Item
    
    invoice_item_record = {:item_id => '2310',
                         :invoice_id => '5603',
                         :quantity => "2",
                         :unit_price => "12412",
                        :created_at => "sometime",
                        :updated_at => "someothertime"}
    invoice_item = @invoice_item_repository.create_record(invoice_item_record)
    
    expected = BigDecimal.new("124.12")
    result = invoice_item.unit_price
    
    assert_equal expected,  result
  end
  def test_we_can_populate_invoices
    assert @invoice_item_repository.records.length > 20
  end

end