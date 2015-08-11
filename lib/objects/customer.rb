require 'set'
require_relative '../modules/record_like.rb'

class Customer
  include RecordLike

  attr_accessor :first_name, :last_name, :created_at, :updated_at,
    :cached_invoices, :cached_paid_invoices, :cached_transactions,
    :cached_paid_invoice_items
  attr_reader :id, :repository

  def initialize(record)
    @id          = record[:id]
    @first_name  = record[:first_name]
    @last_name   = record[:last_name]
    @created_at  = record[:created_at]
    @updated_at  = record[:updated_at]
    @repository  = record.fetch(:repository, nil)
  end

  def invoices
    cached_invoices ||= repository.invoices(self)
  end

  def paid_invoices
    cached_paid_invoices ||= invoices.select{|invoice| invoice.paid?}
  end

  def paid_invoice_items
    cached_paid_invoice_items ||= paid_invoices.map do |invoice|
      invoice.invoice_items
    end.flatten
  end

  def paid_item_quantity
    paid_invoice_items.reduce(0){|acc, ii| acc + ii.quantity}
  end

  def revenue
    paid_invoice_items.reduce(0){|acc, ii| acc + ii.total_price}
  end

  def transactions
    cached_transactions ||= invoices.map do |invoice|
      invoice.transactions
    end.flatten
  end

  def merchants_from_paid_invoices
    paid_invoices.map {|invoice| invoice.merchant }
  end

  def favorite_merchant
    merchants = paid_invoices.group_by{|invoice| invoice.merchant}
    merchants.max_by do |id, invoices|
      invoices.length
    end.first
  end

  def days_since_activity
    latest = transactions.max_by {|trans| trans.updated_at}
    days_since = (DateTime.now - latest.updated_at).to_i
  end

  def pending_invoices
    (Set.new(invoices) - Set.new(paid_invoices)).to_a
  end

end