require 'sqlite3'
require_relative './repos/merchant_repository'
require_relative './repos/invoice_repository'
require_relative './repos/item_repository'
require_relative './repos/invoice_item_repository'
require_relative './repos/customer_repository'
require_relative './repos/transaction_repository'


class SalesEngine
  attr_accessor :merchant_repository, :sql_db
  attr_reader :invoice_repository, :item_repository, :invoice_item_repository,
    :customer_repository, :transaction_repository, :path, :args

  def initialize(path = './data/fixtures/')
    @path = path
    @sql_db ||= SQLite3::Database.new ':memory:'
    @args = {:path => path, :engine => self, :sql_db => @sql_db}
  end

  def startup
    @merchant_repository = MerchantRepository.new(args)
    @invoice_repository = InvoiceRepository.new(args)
    @item_repository = ItemRepository.new(args)
    @invoice_item_repository = InvoiceItemRepository.new(args)
    @customer_repository = CustomerRepository.new(args)
    @transaction_repository = TransactionRepository.new(args)
  end

  def get(args)
    repo = args[:repo]
    use = args[:use]
    self.send(repo).send(use)
  end

  def most_items(x)
    self.item_repository.most_items(x)
  end

  def charge(args, invoice)
    self.transaction_repository.charge(args, invoice)
  end

  def add_items(items, invoice_id)
    self.invoice_item_repository.add_items(items, invoice_id)
  end

  def inspect
    "#{self.class} was initialized with '#{path}'. Good show."
  end

end

if __FILE__  == $0
  engine = SalesEngine.new
  puts "engine starting up..."
  engine.startup
  puts "Done."
end
