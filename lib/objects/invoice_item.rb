require_relative '../modules/record_like.rb'

class InvoiceItem
  include RecordLike

  attr_accessor :item_id, :invoice_id, :quantity , :unit_price, :created_at,
    :updated_at, :cached_invoice, :cached_item, :cached_price
  attr_reader :id, :repository

  def initialize(record)
    @id          = record[:id]
    @item_id     = record[:item_id]
    @invoice_id  = record[:invoice_id]
    @quantity    = record[:quantity]
    @unit_price  = record[:unit_price]
    @created_at  = record[:created_at]
    @updated_at  = record[:updated_at]
    @repository  = record.fetch(:repository, nil)
  end

  def invoice
    cached_invoice ||= repository.get(:invoice, invoice_id, :id).reduce
  end

  def item
    cached_item ||= repository.get(:item, item_id, :id).reduce
  end

  def total_price
    cached_price ||= quantity * unit_price
  end

end