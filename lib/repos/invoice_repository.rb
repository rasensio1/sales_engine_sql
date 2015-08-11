require 'pry'
require_relative '../loader'
require_relative '../objects/invoice'
require_relative './repository'

class InvoiceRepository < Repository

  attr_accessor :cached_paid_invoices, :cached_unpaid_invoices

  def initialize(args)
    super
    filename = args.fetch(:filename, 'invoices.csv')
    path = args.fetch(:path, './data/fixtures/') + filename
    loaded_csvs = Loader.new.load_csv(path)
    @records = build_from(loaded_csvs)
  end

  def create_record(record)
    Invoice.new(record)
  end

  def create_table
    sql_db.execute "create table invoices (id INT, customer_id int,
                                      merchant_id int, status string,
                                       created_at time, updated_at time);"
  end

  def clean_status(match)
    match =~ /\bshipped|unshipped\b/
  end

  def paid_invoices
    cached_paid_invoices ||= all.select(&:paid?)
  end

  def unpaid_invoices
    cached_unpaid_invoices ||= all.reject(&:paid?)
  end

  def pending
    unpaid_invoices
  end

  def average_revenue_all_dates
    sum = BigDecimal.new(invoices_revenue.reduce(:+))
    average = (sum / invoices_revenue.length).round(2)
  end

  def average_revenue(date = "all")
    if date == "all"
      average_revenue_all_dates
    else
      (revenue(date) / invoices_for(date).length).round(2)
    end
  end

  def revenue(date)
    invoices_for(date).reduce(0) do |acc, invoice|
      acc + invoice.total_billed
    end
  end

  def invoices_for(date)
    paid_invoices.select do |invoice|
      invoice.created_at.to_date == date.to_date
    end
  end

  def invoices_revenue
    paid_invoices.map{|invoice| invoice.total_billed}
  end

  def average_items_all_dates
    sum = BigDecimal.new(invoices_items_quantity.reduce(:+))
    average = (sum / invoices_items_quantity.length).round(2)
  end

  def average_items(date = "all")
    if date == "all"
      average_items_all_dates
    else
      iis = invoice_items_for_invoices(invoices_for(date))
      sum = BigDecimal.new(invoices_items_quantity(iis).reduce(:+))
      average = (sum / invoices_items_quantity(iis).length).round(2)
    end
  end

  def invoices_items_quantity(iis = invoice_items_for_invoices)
    iis.map do |iis|
      iis.reduce(0){|acc, iis| acc + iis.quantity}
    end.flatten
  end

  def invoice_items_for_invoices(invoices = paid_invoices)
    invoices.map{|invoice| invoice.invoice_items}
  end

  def paid_invoice_dates
    paid_invoices.map do |invoice|
      invoice.created_at.to_date
    end.uniq
  end

  def items
    args = {:repo => :item_repository,
            :use => :all}
    engine.get(args)
  end

  def quantity_sold(date = "all")
    paid_invoice_items_for(date).reduce(0) do |acc, ii|
      acc + ii.quantity
    end
  end

  def create(args)
    record = {
      :id => next_id,
      :customer_id => (args[:customer].id),
      :merchant_id => (args[:merchant].id),
      :status => args[:status],
      :created_at => timestamp,
      :updated_at => timestamp,
      :repository => self
    }
    items = args[:items]
    records << create_record(record)
    invoice = find_by_id(record[:id])
    invoice.add_items(items)
    invoice
  end

  def charge(args, invoice)
    engine.charge(args, invoice.id)
  end

  def add_items(items, invoice)
    engine.add_items(items, invoice.id)
  end
end
