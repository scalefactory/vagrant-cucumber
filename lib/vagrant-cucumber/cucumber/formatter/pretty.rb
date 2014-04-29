require 'cucumber/formatter/pretty'

module VagrantPlugins

    module Cucumber

        module Formatter

            class Pretty < ::Cucumber::Formatter::Pretty

                # Use the Pretty formatter, but disable use of
                #  delayed messages (ie. output each line at once)

                def initialize(*args)
                    super
                    @delayed_messages = nil
                end

                # print_messages is only used to output the delayed_messages
                #  and fails because of the above hack, so make it a noop

                def print_messages
                end

                def print_table_row_messages
                end

            end

        end

    end

end


