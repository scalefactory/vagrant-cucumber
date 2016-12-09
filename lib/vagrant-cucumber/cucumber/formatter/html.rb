require 'cucumber/formatter/html'

ANSI_PATTERN = /\e\[\d+([;\d]+)?m/

def remove_ansi(string = nil)
    string.gsub(ANSI_PATTERN, '')
end

module VagrantPlugins
    module Cucumber
        module Formatter
            class Html < ::Cucumber::Formatter::Html
                def puts(message)
                    @delayed_messages << remove_ansi(message)
                end
            end
        end
    end
end
