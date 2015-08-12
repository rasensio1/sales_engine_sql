require_relative '../modules/find'
require_relative '../modules/find_by_x'

class Repository
  attr_accessor :records
  attr_reader :engine, :sql_db

  include Find
  include FindByX

  def initialize(args)
    @engine = args.fetch(:engine, nil)
    @sql_db = args.fetch(:sql_db, nil)
  end

  def build_from(loaded_csvs)
    records = []
    loaded_csvs.each do |row|
      row[:repository] = self
      records << create_record(row)
    end
    records
  end

  def table_make
    create_table
    populate_table
    data = sql_db.execute "select * from #{my_table}"
    make_objects(data)
  end

  def make_objects(criteria)
    criteria.map do |row|
      my_object.new(row, self)
    end
  end

  def all
    data = sql_db.execute "select * from #{my_table}"
    make_objects(data)
  end

  def random
    all.sample
  end


  def find_all_by(x, match)
      criteria = sql_db.execute "select * from #{my_table} where #{x} = '#{match}';"
      make_objects(criteria)
  end

  def find_by(x, match)
      criteria = find_all_by(x, match).first
  end

  def get(what, source_key_value, remote_key_name)
    foreign_repo = repo_map[what.to_sym]
    engine.send(foreign_repo).find_all_by(remote_key_name, source_key_value)
  end

  def foreign_key_for(repo, class_name)
    engine.send(repo).holds_type.foreign_keys[class_name]
  end

  def repo_map
    {
      :item => :item_repository,
      :items => :item_repository,
      :invoice => :invoice_repository,
      :invoices => :invoice_repository,
      :transactions => :transaction_repository,
      :invoice_items => :invoice_item_repository,
      :customer => :customer_repository,
      :merchant => :merchant_repository,
      :paid_invoices => :invoice_repository, #not yet used
      :paid_invoice_items => :invoice_item_repository
    }
  end

  def to_dollars(cents)
    cents.round(2)
  end

  def inspect
    "#<#{self.class} #{@records.size} rows>"
  end

  def timestamp
    Time.now.utc.to_s
  end

  def next_id
    all.last.id + 1
  end

end
