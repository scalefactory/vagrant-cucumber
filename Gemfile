source "http://rubygems.org"
source "http://gems.hashicorp.com"

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", :git => "git://github.com/mitchellh/vagrant.git"
  gem "rake"
end

group :plugins do
    gem "vagrant-cucumber", path: "."
    gem "vagrant-multiprovider-snap"
    gem "to_regexp"
    gem "cucumber"
end
