unless defined?(VMRE)
    VMRE = /(?: on the last VM| on the VM(?: called|) "(?:[^"]+)"|)/
end

module VagrantPlugins

    module Cucumber

        module Glue

            # This glue module will be used in the cucumber World for
            #  tests run with vagrant-cucumber.  It's used to hide interaction
            #  with the messier parts of the vagrant environment so the
            #  step definitions don't need to care about them.

            def vagrant_glue
                VagrantGlue.instance
            end

            class VagrantGlue

                def initialize

                    @vagrant_env = Vagrant::Environment.new(
                        :ui_class => Vagrant::UI::Basic
                    )

                    @last_machine_mentioned = nil

                end

                def self.instance
                    return @@instance ||= VagrantGlue.new
                end

                def get_last_vm
                    get_vm( @last_machine_mentioned )
                end

                def get_vm( vmname )

                    machine_provider = nil
                    machine_name     = nil

                    @vagrant_env.active_machines.each do |a_name, a_provider|

                        # XXX per the docs, this won't return VMs that
                        #  haven't been created.  How do we deal with this?
                        
                        if a_name == vmname.to_sym
                            machine_provider = a_provider
                            machine_name     = a_name
                        end

                    end

                    if !machine_name
                        raise Vagrant::Errors::VMNotFoundError, :name => vmname
                    end

                    machine_provider ||= vagrant_env.default_provider
                    machine = @vagrant_env.machine( 
                        machine_name, machine_provider
                    )

                    @last_machine_mentioned = vmname

                    machine

                end

                def identified_vm( str )
                    case str
                        when /^( on the last VM|)$/
                            get_last_vm
                        when /^ on the VM(?: called|) "([^"]+)"$/
                            get_vm( $1 )
                    end
                end

            end


        end

    end

end

