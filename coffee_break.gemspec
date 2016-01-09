# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coffee_break/version'

Gem::Specification.new do |spec|
  spec.name          = "coffee_break"
  spec.version       = CoffeeBreak::VERSION
  spec.authors       = ["Cohen Carlisle"]
  spec.email         = ["cohen.carlisle@gmail.com"]

  spec.summary       = "A gem to handle waiting until a condition is true"
  spec.homepage      = "https://github.com/Cohen-Carlisle/coffee_break"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
