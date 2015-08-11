require 'pry'
require_relative '../loader.rb'
require_relative '../objects/customer.rb'
require_relative './repository'

class CustomerRepository < Repository

  attr_accessor :cached_invoices
  attr_reader :loaded_csvs, :sql_db

  def initialize(args)
    super
    filename = args.fetch(:filename, 'customers.csv')
    path = args.fetch(:path, './data/fixtures/') + filename
    @loaded_csvs = Loader.new.load_csv(path)
    @records = build_from(loaded_csvs)
    @sql_db = args.fetch(:sql_db, nil)
  end

  def create_record(record)
    Customer.new(record)
  end

  def create_table
      sql_db.execute "create table customers (id INT, first_name string,
                                        last_name string, created_at date,
                                        updated_at date);"
  end

  def populate_table
      loaded_csvs.each do |row|
        sql_db.execute "INSERT INTO customers
                        (id, first_name, last_name, created_at, updated_at)
                         VALUES (#{row[:id]}, '#{row[:first_name]}',
                         '#{row[:last_name]}', #{row[:created_at].to_date},
                         #{row[:updated_at].to_date});"
      end
  end

  def invoices(customer)
    cached_invoices ||= begin
      args = {
        :repo => :invoice_repository,
        :use => :all
      }
      engine.get(args)
    end
    cached_invoices.select do |invoice|
      invoice.customer_id == customer.id
    end
  end

  def most_items
    records.max_by{|customer| customer.paid_item_quantity}
  end

  def most_revenue
    records.max_by{|customer| customer.revenue}
  end

end
