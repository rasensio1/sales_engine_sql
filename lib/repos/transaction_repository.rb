require 'pry'
require_relative '../loader'
require_relative '../objects/transaction'
require_relative './repository'

class TransactionRepository < Repository

  attr_accessor :cached_invoices

  def initialize(args)
    super
    filename = args.fetch(:filename, 'transactions.csv')
    path = args.fetch(:path, './data/fixtures/') + filename
    loaded_csvs = Loader.new.load_csv(path)
    @records = build_from(loaded_csvs)
  end

  def create_record(record)
    Transaction.new(record)
  end

  def create_table
    sql_db.execute "create table transactions (id INT, invoice_id int, credit_card_number int,
                                        credit_card_expiration_date int,
                                        result string, created_at time, updated_at time);"  #add values to table
  end

  def get_invoice_for(transaction)
    invoices.select do |invoice|
      invoice.id == transaction.invoice_id
    end.flatten
  end

  def invoices
    cached_invoices ||= begin
      args = {:repo => :invoice_repository,
                :use => :all}
      engine.get(args)
    end
  end

  def count
    all.count{|trans| trans.successful?}
  end

  def charge(args, invoice)
    record = args
    record[:invoice_id] = invoice
    record[:id] = next_id
    record[:result] = args[:result]
    record[:created_at] = timestamp
    record[:updated_at] = timestamp
    records << create_record(record)
  end
end
