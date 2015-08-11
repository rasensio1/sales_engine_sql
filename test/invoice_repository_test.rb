require_relative 'test_helper.rb'
require_relative '../lib/repos/invoice_repository'
require_relative '../lib/sales_engine.rb'

class InvoiceRepositoryTest < Minitest::Test
  
  def setup
    @invoice_repository = InvoiceRepository.new(:path => './fixtures/')
    @se = SalesEngine.new
    @se.startup
    @customer_1 = @se.customer_repository.find_by_id(1)
    @merchant_1 = @se.merchant_repository.find_by_id(1)
    @items = [@se.item_repository.find_by_id(1), @se.item_repository.find_by_id(1), @se.item_repository.find_by_id(2)]

  end  

  def test_make_sure_we_can_instantiate
    assert @invoice_repository.class == InvoiceRepository
  end

  def test_we_can_make_instances_of_Invoice
    
    invoice_record = {:customer_id =>"340", :merchant_id => "3052", :status => "shipped", :created_at=>"2012-03-27 14:53:59 UTC", :updated_at=>"2012-03-27 14:53:59 UTC"}
    invoice = @invoice_repository.create_record(invoice_record)
    
    expected = "340"
    result = invoice.customer_id
    
    assert_equal expected,  result
  end

  def test_we_can_populate_invoices
    assert @invoice_repository.records.length > 20
  end

  def test_we_can_access_a_invoices_info_from_the_invoice_repo_class
    
    expected = 3
    result = @invoice_repository.records[10].customer_id
    
    assert_equal expected, result
  end

  def test_it_creates_a_new_invoice_given_a_hash_of_arguments
    args = {
      customer: @customer_1,
      merchant: @merchant_1,
      status: "shipped",
      items: @items
    }
    @se.invoice_repository.create(args)
    invoice = @se.invoice_repository.find_by_id(88888891)
    # customer. = @se.customer_repository.find_by_id(invoice.customer_id)
    # merchant = @se.merchant_repository.find_by_id(invoice_merchant_id)

    assert_equal invoice.customer_id, @customer_1.id
    assert_equal invoice.merchant_id, @merchant_1.id
  end


  def test_it_creates_a_new_invoice
    customer = @se.customer_repository.find_by_id(7)
    merchant = @se.merchant_repository.find_by_id(22)
    items = [].concat((1..3).map { @se.item_repository.random })
    invoice = @se.invoice_repository.create(customer: customer, merchant: merchant, items: items)

    items.map(&:name).each do |name|
      assert_includes(invoice.items.map(&:name), name, "Missing #{name}")
    end
  end

  def test_it_creates_a_transaction
    customer = @se.customer_repository.find_by_id(7)
    merchant = @se.merchant_repository.find_by_id(22)
    invoice = @se.invoice_repository.find_by_id(3)
        
    prior_transaction_count = invoice.transactions.count
    invoice.charge(credit_card_number: '1111222233334444',  credit_card_expiration_date: "10/14", result: "success")
    invoice = @se.invoice_repository.find_by_id(invoice.id)

    assert_equal invoice.transactions.count, prior_transaction_count.next
  end

end