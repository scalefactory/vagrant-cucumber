# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vagrant-cucumber/version"

Gem::Specification.new do |s|
  s.name        = "vagrant-cucumber"
  s.version     = VagrantPlugins::Cucumber::VERSION
  s.authors     = ["Jon Topper"]
  s.email       = ["jon@scalefactory.com"]
  s.homepage    = ""
  s.summary     = %q{Cucumber support for Vagrant}
  s.description = %q{This plugin makes it possible for Cucumber to interact with Vagrant}

  s.rubyforge_project = "vagrant-cucumber"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  
  s.add_runtime_dependency "cucumber"

end
