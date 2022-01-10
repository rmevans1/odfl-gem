# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'odfl/version'

Gem::Specification.new do |spec|
  spec.name          = "odfl"
  spec.version       = Odfl::VERSION
  spec.authors       = ["Robert Evans"]
  spec.email         = ["robertevans@robertevansmb.com"]
  spec.summary       = %q{Get freight quotes from Old Dominion Freight Line}
  spec.description   = %q{Get freight quotes form ODFL. A valid odfl account is required.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1'

  spec.add_development_dependency "bundler", ">= 1.6"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'codeclimate-test-reporter'

  spec.add_dependency 'savon', '~> 2.8'
end
