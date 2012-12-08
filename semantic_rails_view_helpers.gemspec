# -*- encoding: utf-8 -*-
require File.expand_path('../lib/semantic_rails_view_helpers/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["John Bintz"]
  gem.email         = ["john@coswellproductions.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "semantic_rails_view_helpers"
  gem.require_paths = ["lib"]
  gem.version       = SemanticRailsViewHelpers::VERSION

  gem.add_dependency 'capybara'
  gem.add_dependency 'rspec'
end
