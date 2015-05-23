# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'utf8_gatekeeper/version'

Gem::Specification.new do |gem|
  gem.name          = 'utf8_gatekeeper'
  gem.version       = UTF8Gatekeeper::VERSION
  gem.authors       = ['Ed Robinson']
  gem.email         = ['ed@reevoo.com']
  gem.description   = 'Prevents invalid UTF8 characters from the URL and other env vars reaching your app'
  gem.summary       = 'Prevent annoying error reports of "invalid byte sequence in UTF-8"'
  gem.homepage      = 'https://github.com/reevoo/utf8_gatekeeper'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.test_files    = gem.files.grep(/^spec\//)
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rack'
  gem.add_development_dependency 'codeclimate-test-reporter'
  gem.add_development_dependency 'reevoocop'
end
