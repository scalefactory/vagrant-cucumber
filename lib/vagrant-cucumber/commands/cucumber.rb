require 'cucumber/rspec/disable_option_parser'
require 'cucumber/cli/main'

module VagrantPlugins
    module Cucumber
        class CucumberCommand < Vagrant.plugin(2, :command)

            def execute

                opts = OptionParser.new do |o|
                end

                argv = parse_options(opts)
                failure = ::Cucumber::Cli::Main.execute(argv)    

            end

        end
    end
end

