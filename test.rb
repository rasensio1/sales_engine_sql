require 'pry'
module TestModule
  def say_hi
    'hi'
  end
end
class TestClass
  include TestModule
end

test = TestClass.new

puts test.say_hi

