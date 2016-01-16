require "coffee_break/version"
require "coffee_break/errors"
require "coffee_break/default"
require "coffee_break/waiter/coffee"

module CoffeeBreak
  def self.until(timeout: DEFAULT[:timeout], interval: DEFAULT[:interval],
                 rescues: DEFAULT[:rescues], raise:    DEFAULT[:raise],
                 message: nil,               &block)

    Waiter::Coffee.break(timeout: timeout, interval: interval, rescues: rescues,
                         raise: raise).until(message: message, &block)
  end

  def self.default_timeout
    DEFAULT[:timeout]
  end

  def self.default_timeout=(seconds)
    DEFAULT[:timeout] = seconds
  end

  def self.default_interval
    DEFAULT[:interval]
  end

  def self.default_interval=(seconds)
    DEFAULT[:interval] = seconds
  end

  def self.default_rescues
    DEFAULT[:rescues]
  end

  def self.default_rescues=(exceptions)
    DEFAULT[:rescues] = exceptions
  end

  def self.default_raise
    DEFAULT[:raise]
  end

  def self.default_raise=(boolean)
    DEFAULT[:raise] = boolean
  end
end
