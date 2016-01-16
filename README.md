# CoffeeBreak

A gem to handle waiting until a condition is true.

## About

By default, CoffeeBreak calls the supplied block every 0.1 seconds while the
result of calling the block is falsey. If the block returns a truthy value, that
value is returned and program execution resumes. If the block isn't truthy
before the default timeout period of 30 seconds, a `CoffeeBreak::TimeoutError`
is raised.

## Usage

```ruby
require 'coffee_break'
include CoffeeBreak::Waiter

Coffee.break.until { 2 + 2 }      # => returns 4
Coffee.break.until { 2 + 2 == 4 } # => returns true
Coffee.break.until { 2 + 2 == 5 } # => raises CoffeeBreak::TimeoutError
```

The timeout and time between block calls (interval) can be set in two ways:

```ruby
## Universal default
CoffeeBreak.default_timeout = 5
CoffeeBreak.default_interval = 0.1
## One time setting
Coffee.break(timeout: 5, interval: 0.1).until { foo }
```

Similarly, you can tell CoffeeBreak to rescue either one class of errors or an
array of error classes that the block could raise.

```ruby
## Universal default
CoffeeBreak.default_rescues = NameError
# or CoffeeBreak.default_rescues = [ArgumentError, NoMethodError]
## One time setting
Coffee.break(rescues: [TypeError, ZeroDivisionError]).until { foo }
# or Coffee.break(rescues: RuntimeError).until { foo }
```

You can also tell CoffeeBreak not to raise an error on timeout. Instead, the
result of calling the block is returned.

```ruby
## Universal default
CoffeeBreak.default_raise = false
## One time setting
Coffee.break(raise: false).until { falsey } # => returns false or nil
```

Finally, you can provide a message to be used if your block times out. If a
`CoffeeBreak::TimeoutError` is raised, this will replace the default error
message. If a timeout occurs but no error is raised (you set raise to `false`),
the message will print as a warning (otherwise no warning is printed). This is
only set in `until` (not `break`) and the universal default can't be changed.

```ruby
## One time setting
Coffee.break.until(message: "foo couldn't bar") { foo.bar }
```

If you don't want `Coffee` in your top level namespace or don't like the above
syntax, you can use the alternate syntax below. Note that `message` and the
configuration arguments are all passed to `until`, unlike the above syntax which
keeps your configuration and `message` arguments separate.

```ruby
CoffeeBreak.until(message: 'No yo', timeout: 5, raise: false) { Yo.yo? }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org]
(https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/Cohen-Carlisle/coffee_break.


## License

The gem is available as open source under the terms of the [MIT License]
(http://opensource.org/licenses/MIT).
