# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exceptiontrap/version"

Gem::Specification.new do |s|
  s.name        = "exceptiontrap"
  s.version     = Exceptiontrap::VERSION
  s.authors     = ["tbuehl"]
  s.email       = ["tbuehl@itm-labs.de"]
  s.homepage    = "http://exceptiontrap.com"
  s.summary     = %q{Used to report your apps exceptions to the exceptiontrap webservice}
  s.description = %q{The gem catches your applications exceptionts and sends those to the exceptiontrap webservice}

  s.rubyforge_project = "exceptiontrap"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end