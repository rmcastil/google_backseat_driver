# -*- encoding: utf-8 -*-
require File.expand_path('../lib/backseat_driver/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryan Castillo"]
  gem.email         = ["rmcastil@gmail.com"]
  gem.description   = %q{A wrapper for Google's Drive gem}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "backseat_driver"
  gem.require_paths = ["lib"]
  gem.version       = BackseatDriver::VERSION

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'cucumber'
end
