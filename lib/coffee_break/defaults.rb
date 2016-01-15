module CoffeeBreak
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

  # private

  DEFAULT = {
    timeout: 30,
    interval: 0.1,
    rescues: [],
    raise: true
  }
end
