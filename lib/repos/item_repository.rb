require 'bigdecimal'
require_relative '../loader.rb'
require_relative '../objects/item'
require_relative './repository'


class ItemRepository < Repository

  attr_accessor :cached_paid_invoice_items
  attr_reader :loaded_csvs

  def initialize(args)
    super
    filename = args.fetch(:filename, 'items.csv')
    path = args.fetch(:path, './data/fixtures/') + filename
    @loaded_csvs = Loader.new.load_csv(path)
    @records = build_from(loaded_csvs)
  end

  def create_record(record)
    record[:unit_price] = BigDecimal.new(record[:unit_price]) / 100
    Item.new(record)
  end

  def create_table
      sql_db.execute "create table items (id INT, name string,
                                        description string, unit_price int,
                                        merchant_id int, created_at time,
                                        updated_at time);"
  end

  def populate_table
      loaded_csvs.each do |row|
        sql_db.execute "INSERT INTO items
                        (id, name, description, unit_price, merchant_id,
                                                  created_at, updated_at)
                         VALUES (#{row[:id]}, '#{row[:name]}',
                         '#{row[:description]}', #{row[:unit_price]},
                         #{row[:merchant_id]}, #{row[:created_at].to_date},
                         #{row[:updated_at].to_date});"
      end
  end

  def paid_invoice_items(item)
    cached_paid_invoice_items ||= begin
      args = {
        :repo => :invoice_item_repository,
        :use => :paid_invoice_items
      }
      engine.get(args)
    end
    cached_paid_invoice_items.select do |ii|
      ii.item_id == item.id
    end
  end

  def paid_invoices(for_item)
    paid_invoice_items(for_item).map {|ii| ii.invoice}.uniq
  end

  def most_revenue(x)
    all.max_by(x) {|item| item.revenue}
  end

  def most_items(x)
    all.max_by(x) {|item| item.quantity_sold}
  end

end
