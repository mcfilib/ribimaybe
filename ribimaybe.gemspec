# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "version"

Gem::Specification.new do |spec|
  spec.name          = "ribimaybe"
  spec.version       = Ribimaybe::VERSION
  spec.authors       = ["unsymbol"]
  spec.email         = ["hello@philipcunningham.org"]
  spec.description   = "Maybe Functor, Applicative and Monad"
  spec.summary       = "A tiny Ruby library that provides a Maybe datatype which is a Functor, Applicative Functor and Monad instance."
  spec.homepage      = "https://github.com/unsymbol/ribimaybe"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency     "contracts", "~> 0.4"
end
