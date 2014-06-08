# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ribimaybe"

Gem::Specification.new do |spec|
  spec.name          = "ribimaybe"
  spec.version       = Ribimaybe::VERSION
  spec.authors       = ["unsymbol"]
  spec.email         = ["hello@philipcunningham.org"]
  spec.description   = "Maybe Datatype"
  spec.summary       = "Maybe as a Functor, Applicative and Monad in Ruby"
  spec.homepage      = "https://github.com/unsymbol/ribimaybe"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
