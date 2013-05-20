module VagrantPlugins
    module Cucumber
        class CucumberCommand < Vagrant.plugin(2, :command)

            def execute

                require 'cucumber/rspec/disable_option_parser'
                require 'cucumber/cli/main'

                require 'vagrant-cucumber/cucumber/formatter/pretty'
                require 'vagrant-cucumber/cucumber/formatter/html'

                failure = ::Cucumber::Cli::Main.execute(@argv)    

            end

        end
    end
end

