require 'cucumber/formatter/html'

module VagrantPlugins

    module Cucumber

        module Formatter

            class Html < ::Cucumber::Formatter::Html

                def puts(message)
                    # TODO Strip ansi escape codes
                    @delayed_messages << message
                end

            end 

        end

    end

end


