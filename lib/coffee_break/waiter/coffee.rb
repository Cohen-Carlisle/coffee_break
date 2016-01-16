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

      def until(message: nil)
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
        if @raise
          raise(TimeoutError, message || "Timed out after #{@timeout} seconds")
        else
          warn message if message
          result
        end
      end
    end
  end
end
