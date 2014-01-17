# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'markdevn/version'

Gem::Specification.new do |spec|
  spec.name          = "markdevn"
  spec.version       = Markdevn::VERSION
  spec.authors       = ["Joel"]
  spec.email         = ["me@joelt.io"]
  spec.description   = %q{Markdevn converts Evernote note documents to and from Markdown.}
  spec.summary       = %q{Convert Evernote to Markdown and back}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "debugger"

  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "redcarpet"
end
