$:.push File.expand_path("../lib", __FILE__)
require 'carousel/version'

Gem::Specification.new do |spec|
  spec.name          = "carousel-ruby-api"
  spec.version       = Carousel::VERSION
  spec.authors       = ["Justin Grubbs"]
  spec.email         = ["justin@sellect.com"]
  spec.description   = %q{Ruby Library for Carousel Fulfillment API}
  spec.summary       = %q{This is a library for interfacing with the Carousel Fulfillment API}
  spec.homepage      = "http://sellect.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "builder"
  spec.add_dependency "xml-simple"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "hashie"
  spec.add_development_dependency "codeclimate-test-reporter"
end
