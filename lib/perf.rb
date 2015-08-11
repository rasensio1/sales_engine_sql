require_relative 'sales_engine'

  engine = SalesEngine.new('./data/')
  puts "engine starting up..."
  engine.startup
  puts "Done."

start = Time.now
2000.times do |time|
  engine.customer_repository.find_by_id(time)
end
finish = Time.now

difference = finish - start
puts "Time taken is #{difference} seconds"

