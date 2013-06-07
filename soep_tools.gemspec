# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soep_tools/version'

Gem::Specification.new do |spec|
  spec.name          = "soep_tools"
  spec.version       = SoepTools::VERSION
  spec.authors       = ["mhebing"]
  spec.email         = ["mhebing@diw.de"]
  spec.description   = "Collections of Ruby tools for the SOEP"
  spec.summary       = "To use in combination with other tools like QLIB, Pretests, etc."
  spec.homepage      = "http://diw.de/soep"
  spec.license       = "undefined"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency "nokogiri"
end
