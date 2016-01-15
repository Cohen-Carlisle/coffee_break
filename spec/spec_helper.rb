$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'benchmark'
require 'coffee_break'
include CoffeeBreak::Waiter
CoffeeBreak::DEFAULT[:interval] = 0.001
CoffeeBreak::DEFAULT[:timeout]  = 0.01
RSpec.configure do |config|
  config.before(:example, reset: true) do
    @defaults = CoffeeBreak::DEFAULT.dup
  end

  config.after(:example, reset: true) do
    @defaults.each { |k,v| CoffeeBreak::DEFAULT[k] = v }
  end
end
