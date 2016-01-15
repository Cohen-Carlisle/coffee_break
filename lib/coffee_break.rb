require "coffee_break/version"
require "coffee_break/errors"
require "coffee_break/defaults"
require "coffee_break/waiter/coffee"

module CoffeeBreak
  def self.until(timeout: DEFAULT[:timeout], interval: DEFAULT[:interval],
                 rescues: DEFAULT[:rescues], raise:    DEFAULT[:raise],
                 message: "Timed out after #{timeout} seconds", &block)

    Waiter::Coffee.break(timeout: timeout, interval: interval, rescues: rescues,
                         raise: raise).until(message: message, &block)
  end
end
