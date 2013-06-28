source "http://rubygems.org"
source "http://gems.hashicorp.com"

# Specify your gem's dependencies in vagrant-cucumber.gemspec
gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant",                       :git => "git://github.com/mitchellh/vagrant.git"
  gem "vagrant-zz-multiprovider-snap", :git => "git@github.com:scalefactory/vagrant-multiprovider-snap.git"
end

gem "vagrant-vmware-fusion"
gem "to_regexp"
