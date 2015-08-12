require 'bigdecimal'
require_relative '../loader.rb'
require_relative '../objects/invoice_item.rb'
require_relative './repository'

class InvoiceItemRepository < Repository
  attr_reader :loaded_csvs, :my_object, :my_table, :sql_db


  def initialize(args)
    super
    filename = args.fetch(:filename, 'invoice_items.csv')
    path = args.fetch(:path, './data/fixtures/') + filename
    @loaded_csvs = Loader.new.load_csv(path)
    @my_object = InvoiceItem
    @my_table = 'invoice_items'
    @sql_db = args.fetch(:sql_db, nil)
    @records = table_make
  end

  def create_record(record)
    record['unit_price'] = BigDecimal.new(record['unit_price']) / 100
    InvoiceItem.new(record)
  end

  def create_table
      sql_db.execute "create table invoice_items (id INT, item_id int,
                                        invoice_id int, quantity int,
                                        unit_price int, created_at time,
                                        updated_at time);"
  end

  def populate_table
      loaded_csvs.each do |row|
        sql_db.execute "INSERT INTO invoice_items
                        (id, item_id, invoice_id, quantity, unit_price, created_at, updated_at)
                         VALUES (#{row[:id]}, '#{row[:item_id]}',
                         '#{row[:invoice_id]}', '#{row[:quantity]}',
                         '#{row[:unit_price]}', #{row[:created_at].to_date},
                         #{row[:updated_at].to_date});"
      end
  end
  #
  # def transactions
  #   create_table
  #   populate_table
  #   data = sql_db.execute "select * from transactions"
  #   data.map do |row|
  #     Transaction.new(row, self)
  #   end
  # end

  def paid_invoice_items
    args = {:repo => :invoice_repository, :use => :paid_invoices}
    @paid_invoices ||= engine.get(args)
    @paid_invoice_items ||= @paid_invoices.map do |invoice|
      invoice.invoice_items
    end.flatten
  end

  def add_items(items, invoice_id)
    items.each do |item|
      record = {
        :id => next_id,
        :invoice_id => invoice_id,
        :item_id => item.id,
        :unit_price => item.unit_price,
        :repository => item.repository,
        :created_at => timestamp,
        :updated_at => timestamp
      }
      records << create_record(record)
      end
  end

end
