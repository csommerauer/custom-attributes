# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'custom_attributes/version'

Gem::Specification.new do |spec|
  spec.name          = "custom_attributes"
  spec.version       = CustomAttributes::VERSION
  spec.authors       = ["Christian Sommerauer"]
  spec.email         = ["christian@picturk.com"]
  spec.description   = %q{Enable models instances to have additional attributes}
  spec.summary       = %q{Enable models instances to have additional attributes}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', ['>= 3', '<4']
  spec.add_dependency 'paperclip'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pry"
end
