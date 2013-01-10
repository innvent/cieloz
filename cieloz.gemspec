# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cieloz/version'

Gem::Specification.new do |gem|
  gem.name          = "cieloz"
  gem.version       = SpreeCielo::VERSION
  gem.authors       = ["Fábio Luiz Nery de Miranda"]
  gem.email         = ["fabio@miranti.net.br"]
  gem.description   = %q{A utility gem for Spree Gateway gem}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/fabiolnm/cieloz"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "turn"
  gem.add_development_dependency "fakeweb"
  gem.add_development_dependency "nokogiri"
  gem.add_development_dependency "debugger"
  gem.add_development_dependency "activesupport"
  gem.add_development_dependency "activemodel"
end