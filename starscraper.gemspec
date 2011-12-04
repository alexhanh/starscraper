# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "starscraper/version"

Gem::Specification.new do |s|
  s.name        = "starscraper"
  s.version     = Starscraper::VERSION
  s.authors     = ["Alexander Hanhikoski"]
  s.email       = ["alexander.hanhikoski@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{StarCraft II Battle.net profile crawler.}
  s.description = %q{StarCraft II Battle.net profile crawler.}

  s.rubyforge_project = "starscraper"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_dependency('httparty', '~>0.8.1')
  s.add_dependency('nokogiri', '~>1.5.0')
end
