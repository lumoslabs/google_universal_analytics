# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_universal_analytics/version'

Gem::Specification.new do |spec|
  spec.name          = "google_universal_analytics"
  spec.version       = GoogleUniversalAnalytics::VERSION
  spec.authors       = ["David Boctor"]
  spec.email         = ["dboctor@lumoslabs.com"]
  spec.description   = %q{simple interface for Google Universal Analytics}
  spec.summary       = %q{simple interface for Google Universal Analytics}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
end
