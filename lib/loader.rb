require 'csv'
require 'date'

class Loader

  def load_csv(str)
    records  = []
    args = {:headers => true,
            :header_converters => :symbol,
            :converters => :all}
    CSV.foreach(str, args) do |row|
        headers = row.headers[0..-1]
        fields = row.fields[0..-1]
        fields[-2] = DateTime.parse(fields[-1])
        fields[-1] = DateTime.parse(fields[-1])
        records << Hash[headers.zip(fields)]
    end
    records
  end

end