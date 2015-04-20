require 'cucumber/term/ansicolor'

FORCE_COLOUR_ENV_VARS = [
    'VAGRANT_CUCUMBER_FORCE_COLOR',
    'VAGRANT_CUCUMBER_FORCE_COLOUR',
]

module VagrantPlugins
    module Cucumber
        module Term
            module ANSIColor
                include ::Cucumber::Term::ANSIColor

                force_colour = false
                FORCE_COLOUR_ENV_VARS.each { |k|
                    if ENV.has_key?(k)
                        force_colour = true
                        break
                    end
                }

                if force_colour
                        ::Cucumber::Term::ANSIColor.coloring = true
                end

                def self.coloring?
                    if force_colour
                        true
                    else
                        @coloring
                    end
                end

                def self.coloring=(val)
                    if force_color
                        @coloring = true
                    else
                        @coloring = val
                    end
                end
            end
        end
    end
end
