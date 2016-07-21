source 'http://rubygems.org'
source 'http://gems.hashicorp.com'

require 'fileutils'

embedded_locations = %w(/Applications/Vagrant/embedded /opt/vagrant/embedded)

embedded_locations.each do |p|
    ENV['VAGRANT_INSTALLER_EMBEDDED_DIR'] = p if File.directory?(p)
end

unless ENV.key?('VAGRANT_INSTALLER_EMBEDDED_DIR')
    $stderr.puts "Couldn't find a packaged install of vagrant, and we need this"
    $stderr.puts 'in order to make use of the RubyEncoder libraries.'
    $stderr.puts 'I looked in:'
    embedded_locations.each do |p|
        $stderr.puts "  #{p}"
    end
end

group :development do
    # We depend on Vagrant for development, but we don't add it as a
    # gem dependency because we expect to be installed within the
    # Vagrant environment itself using `vagrant plugin`.

    gem 'vagrant', git: 'git://github.com/mitchellh/vagrant.git'
    gem 'rake'

    if ENV['VAGRANT_DEFAULT_PROVIDER'] == 'vmware_fusion'
        # Jump through annoying hoops so we can use this plugin in the
        # bundler environment.

        fusion_gem  = Gem::Specification.find_by_name('vagrant-vmware-fusion')
        fusion_path = fusion_gem.gem_dir
        fusion_license_path = File.join(
            fusion_path,
            'license-vagrant-vmware-fusion.lic',
        )
        fusion_license_vagrantd_path = File.join(
            ENV['HOME'],
            '.vagrant.d',
            'license-vagrant-vmware-fusion.lic',
        )

        rgloader_local_path    = File.join(fusion_path, 'rgloader')
        rgloader_embedded_path = File.join(
            ENV['VAGRANT_INSTALLER_EMBEDDED_DIR'],
            'rgloader',
        )

        unless File.symlink?(rgloader_local_path)
            $stderr.puts "Linking local 'rgloader' file to embedded installer"
            FileUtils.ln_s(rgloader_embedded_path, rgloader_local_path)
        end

        unless File.symlink?(fusion_license_path)
            $stderr.puts 'Linking your license file for vmware plugin'
            FileUtils.ln_s(fusion_license_vagrantd_path, fusion_license_path)
        end
    end
end

group :plugins do
    gem 'vagrant-vmware-fusion'
    gem 'vagrant-cucumber', path: '.'
    gem 'to_regexp'
    gem 'cucumber'
end
