require 'spec_helper'

describe CoffeeBreak do
  it 'has a version number' do
    expect(CoffeeBreak::VERSION).not_to be nil
  end

  describe '#until' do
    it 'can call Coffee::break and Coffee#until' do
      break_args = {timeout: 9, interval: 8, rescues: 7, raise: 6}
      until_args = {message: 5}
      until_blok = -> { 4 }
      coffee_obj = instance_double(Coffee)
      expect(Coffee).to receive(:break).with(break_args).and_return(coffee_obj)
      expect(coffee_obj).to receive(:until).with(until_args).and_yield
      CoffeeBreak.until(break_args.merge(until_args), &until_blok)
    end
  end

  context 'can set and get', reset: true do
    it 'default_timeout' do
      CoffeeBreak.default_timeout = 0.05
      expect(CoffeeBreak.default_timeout).to eq 0.05
      interval = CoffeeBreak.default_interval
      time = Benchmark.measure { Coffee.break(raise: false).until { false } }
      expect(time.real).to be_between(0.05, 0.05 + interval * 2)
    end

    it 'default_interval' do
      CoffeeBreak.default_interval = 0.002
      expect(CoffeeBreak.default_interval).to eq 0.002
      timeout = CoffeeBreak.default_timeout
      counter = 0
      increment_counter = -> { counter += 1; false }
      Coffee.break(raise: false).until(&increment_counter)
      expect(counter).to eq(timeout / 0.002).or eq(timeout / 0.002 + 1)
    end

    it 'default_rescues with class argument' do
      CoffeeBreak.default_rescues = ArgumentError
      expect(CoffeeBreak.default_rescues).to eq ArgumentError
      would_raise_argument_error = -> do
        Coffee.break(raise: false).until { Object.new(1) }
      end
      expect(would_raise_argument_error).not_to raise_error
    end

    it 'default_rescues with array argument' do
      CoffeeBreak.default_rescues = [ArgumentError, NoMethodError]
      expect(CoffeeBreak.default_rescues).to eq [ArgumentError, NoMethodError]
      would_raise_no_method_error = -> do
        Coffee.break(raise: false).until { Object.new.potato }
      end
      expect(would_raise_no_method_error).not_to raise_error
    end

    it 'default_raise' do
      CoffeeBreak.default_raise = false
      expect(CoffeeBreak.default_raise).to eq false
      would_raise_timeout_error = -> do
        Coffee.break.until { 2 + 2 == 5 }
      end
      expect(would_raise_timeout_error).not_to raise_error
    end
  end

  describe Coffee do
    describe '::break' do
      it 'can set the timeout' do
        interval = CoffeeBreak.default_interval
        coffee_break = Coffee.break(raise: false, timeout: 0.05)
        time = Benchmark.measure { coffee_break.until { 2 + 2 == 5 } }
        expect(time.real).to be_between(0.05, 0.05 + interval * 2)
      end

      it 'can set the interval' do
        timeout = CoffeeBreak.default_timeout
        counter = 0
        increment_counter = -> { counter += 1; false }
        Coffee.break(raise: false, interval: 0.002).until(&increment_counter)
        expect(counter).to eq(timeout / 0.002).or eq(timeout / 0.002 + 1)
      end

      it 'can set the rescues with class argument' do
        cb = Coffee.break(raise: false, rescues: ArgumentError)
        would_raise_argument_error = -> do
          cb.until { Object.new(1) }
        end
        expect(would_raise_argument_error).not_to raise_error
      end

      it 'can set the rescues with array argument' do
        cb = Coffee.break(raise: false, rescues: [ArgumentError, NoMethodError])
        would_raise_no_method_error = -> do
          cb.until { Object.new.potato }
        end
        expect(would_raise_no_method_error).not_to raise_error
      end

      it 'can set the raise' do
        would_raise_timeout_error = -> do
          Coffee.break(raise: false).until { 2 + 2 == 5 }
        end
        expect(would_raise_timeout_error).not_to raise_error
      end
    end

    describe '#until' do
      context 'when the block evaluates to a truthy value' do
        it 'returns the result' do
          expect(Coffee.break.until { 2 + 2 == 4 }).to be true
          expect(Coffee.break.until { 'truthy' }).to eq 'truthy'
        end

        it 'returns immediately' do
          time = Benchmark.measure { Coffee.break(timeout: 1).until { true } }
          expect(time.real).to be < 0.001
        end

        it 'evaluates the block at least once' do
          counter = 0
          expect(Coffee.break(timeout: -1).until { counter += 1 }).to eq 1
          expect(counter).to eq 1
        end
      end

      context 'when the block evaluates to a falsey value' do
        it 'raises a TimeoutError with a default error message by default' do
          error = CoffeeBreak::TimeoutError
          message = "Timed out after #{CoffeeBreak::default_timeout} seconds"
          with_falsey_block = -> { Coffee.break.until { 2 + 2 == 5 } }
          expect(with_falsey_block).to raise_error(error, message)
        end

        it 'can report a custom error message' do
          custom_message = 'This is a custom message'
          timeout = -> { Coffee.break.until(message: custom_message) { false } }
          expect(timeout).to raise_error(custom_message)
        end

        it 'returns the result if configured not to raise error on timeout' do
          coffee_break = Coffee.break(raise: false)
          expect(coffee_break.until { 2 + 2 == 5 }).to be false
          expect(coffee_break.until { nil }).to be nil
        end

        it 'continues evaluating the block until timeout' do
          interval = CoffeeBreak.default_interval
          coffee_break = Coffee.break(raise: false, timeout: 0.05)
          time = Benchmark.measure { coffee_break.until { 2 + 2 == 5 } }
          expect(time.real).to be_between(0.05, 0.05 + interval * 2)
        end

        it 'can rescue errors during wait and then raise TimeoutError' do
          rescue_and_raise = -> do
            Coffee.break(rescues: RuntimeError).until { raise }
          end
          expect(rescue_and_raise).to raise_error(CoffeeBreak::TimeoutError)
        end

        it 'evaluates the block at least once' do
          counter = 0
          negative_timer = -> do
            Coffee.break(timeout: -1).until { counter += 1; false }
          end
          expect(negative_timer).to raise_error(CoffeeBreak::TimeoutError)
          expect(counter).to eq 1
        end
      end
    end
  end
end
