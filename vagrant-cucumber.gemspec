# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vagrant-cucumber/version"

Gem::Specification.new do |s|
  s.name        = "vagrant-cucumber"
  s.version     = VagrantPlugins::Cucumber::VERSION
  s.authors     = ["Jon Topper"]
  s.email       = ["jon@scalefactory.com"]
  s.homepage    = "https://github.com/scalefactory/vagrant-cucumber"
  s.summary     = %q{Cucumber support for Vagrant}
  s.description = %q{This plugin makes it possible for Cucumber to interact with Vagrant}
  s.license     = 'MIT'

  s.rubyforge_project = "vagrant-cucumber"

  files = `git ls-files`.split("\n")
  ignore = %w{Gemfile Rakefile .gitignore}

  files.delete_if do |f|
      ignore.any? do |i|
          File.fnmatch(i, f, File::FNM_PATHNAME) ||
          File.fnmatch(i, File.basename(f), File::FNM_PATHNAME)
      end
  end
  
  s.add_runtime_dependency "cucumber", ">=1.3.2"
  s.add_runtime_dependency "vagrant-multiprovider-snap", ">=0.0.4"
  s.add_runtime_dependency "to_regexp", ">=0.2.1"

  s.files         = files
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
