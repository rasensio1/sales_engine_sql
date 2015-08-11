require 'date'
require_relative 'test_helper.rb'
require_relative '../lib/loader'

class LoaderTest < Minitest::Test
  def setup
    @loader = Loader.new
  end

  def test_it_doesnt_need_any_args_to_instantiate
    assert @loader
  end

  def test_it_loads_an_array_of_hashes
    raw_table = @loader.load_csv('./fixtures/merchants.csv')
    
    assert_kind_of(Array, raw_table, "Loaded table is not an array")
    assert_kind_of(Hash, raw_table.last)
    assert_kind_of(Hash, raw_table.first)
  end
end