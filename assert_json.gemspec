# encoding: utf-8

$:.push File.expand_path("../lib", __FILE__)
require "assert_json/version"

Gem::Specification.new do |s|
  s.name = "assert_json"
  s.version = AssertJson::VERSION
  s.summary = "A gem to test JSON strings."
  s.description = "A gem to test JSON strings."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md"]

  s.authors = ["Thorsten Böttger", "Ralph von der Heyden", "Matthias Grosser"]
  s.email = %q{mtgrosser@gmx.net}
  s.homepage = %q{https://github.com/onrooby/assert_json}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport'
  s.add_development_dependency 'minitest'
end
