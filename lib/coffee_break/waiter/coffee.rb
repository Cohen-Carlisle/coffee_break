module CoffeeBreak
  module Waiter
    class Coffee
      def initialize(timeout: DEFAULT[:timeout], interval: DEFAULT[:interval],
                     rescues: DEFAULT[:rescues], raise:    DEFAULT[:raise])

        @timeout  = timeout
        @interval = interval
        @rescues  = rescues
        @raise    = raise
      end

      class << self
        alias break new
      end

      def until(message: "Timed out after #{@timeout} seconds")
        result = nil
        end_time = Time.now + @timeout
        loop do
          begin
            result = yield
            return result if result
          rescue *@rescues
          end
          break if Time.now >= end_time
          sleep @interval
        end
        @raise ? raise(TimeoutError, message) : result
      end
    end
  end
end
