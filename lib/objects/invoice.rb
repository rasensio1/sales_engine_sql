require_relative '../modules/record_like.rb'
require_relative 'transaction'

class Invoice
  include RecordLike

  attr_accessor :customer_id, :merchant_id, :status , :created_at,
    :updated_at, :cached_transactions, :cached_invoice_items, :cached_items,
    :cached_customer, :cached_merchant
  attr_reader :id, :repository, :db

  def initialize(record, repository)
    @id = record['id']
    @customer_id = record['customer_id']
    @merchant_id = record['merchant_id']
    @status      = record['status']
    @created_at  = record['created_at']
    @updated_at  = record['updated_at']
    @repository  = repository
    @db          = repository.sql_db
  end

  def transactions
    criteria = db.execute "select * from transactions where invoice_id = #{id};"
    criteria.map do |row|
      Transaction.new(row, @repository.engine.transaction_repository)
    end
  end

  def invoice_items
    cached_invoice_items ||= repository.get(:invoice_items, id, :invoice_id)
  end

  def items
    cached_items ||= invoice_items.map do |ii|
      repository.get(:items, ii.item_id, :id)
    end.flatten
  end

  def customer
    cached_customer ||= repository.get(:customer, customer_id, :id).reduce
  end

  def merchant
    cached_merchant ||= repository.get(:merchant, merchant_id, :id).reduce
  end

  def paid?
    transactions.any? {|transaction| transaction.successful?}
  end

  def total_billed
    invoice_items.reduce(0) do |acc, ii|
      acc + ii.total_price
    end
  end

  def add_items(items)
    repository.add_items(items, self)
  end

  def charge(args)
    repository.charge(args, self)
  end
end
