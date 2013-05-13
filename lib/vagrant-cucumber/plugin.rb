begin
    require "vagrant"
rescue LoadError
    raise "The Vagrant AWS plugin must be run within Vagrant."
end

module VagrantPlugins
    module Cucumber 
        class Plugin < Vagrant.plugin("2")

            name "Cucumber"

            description <<-DESC
            This plugin makes it possible for Cucumber to interact with Vagrant
            DESC

            command "cucumber" do
                require_relative "commands/cucumber"
                CucumberCommand
            end

        end
    end
end
