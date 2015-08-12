require 'pry'
require_relative '../loader'
require_relative '../objects/transaction'
require_relative './repository'
require 'date'

class TransactionRepository < Repository

  attr_accessor :cached_invoices
  attr_reader :loaded_csvs, :my_object, :my_table, :sql_db

  def initialize(args)
    super
    filename = args.fetch(:filename, 'transactions.csv')
    path = args.fetch(:path, './data/fixtures/') + filename
    @loaded_csvs = Loader.new.load_csv(path)
    @my_object = Transaction
    @my_table = 'transactions'
    @sql_db = args.fetch(:sql_db, nil)
    @records = table_make

  end

  def create_record(record)
    Transaction.new(record, self)
  end

  def create_table
    sql_db.execute "create table transactions
                    (id INT, invoice_id int, credit_card_number int,
                    credit_card_expiration_date string,
                    result string, created_at date, updated_at date);"  #add values to table
  end

  def populate_table
      loaded_csvs.each do |row|
        sql_db.execute "INSERT INTO transactions (id, invoice_id,
                        credit_card_number, result, created_at, updated_at)
                        VALUES (#{row[:id]}, #{row[:invoice_id]},
                        #{row[:credit_card_number]}, '#{row[:result]}',
                        #{row[:created_at].to_date},
                        #{row[:updated_at].to_date});"
      end
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
