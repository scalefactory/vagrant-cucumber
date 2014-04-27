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

                @@vagrant_env = nil

                def self.set_environment(env)
                    @@vagrant_env = env
                end

                def initialize

                    @vagrant_env = @@vagrant_env or raise "The vagrant_env hasn't been set"
                    @last_machine_mentioned = nil

                end

                def self.instance
                    return @@instance ||= VagrantGlue.new
                end

                def vagrant_env
                    @vagrant_env
                end

                def get_last_vm
                    get_vm( @last_machine_mentioned )
                end

                def get_vm( vmname )

                    machine_provider = nil
                    machine_name     = nil

                    # If this machine name is not configured, blow up
                    if ! @vagrant_env.machine_names.index(vmname.to_sym)
                        raise Vagrant::Errors::VMNotFoundError, :name => vmname
                    end

                    @vagrant_env.active_machines.each do |a_name, a_provider|

                        if a_name == vmname.to_sym
                            machine_provider = a_provider
                            machine_name     = a_name
                        end

                    end

                    if !machine_name

                        raise "The VM '#{vmname}' is configured in the Vagrantfile "+
                            "but has not been started.  Run 'vagrant up #{vmname}' and "+
                            "specify a provider if necessary."

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


                attr_reader :last_shell_command_status
                attr_reader :last_shell_command_output

                def execute_on_vm ( command, machine, opts = {} )

                    @last_shell_command_output = {
                        :stdout => '',
                        :stderr => '',
                    }

                    @last_shell_command_status = nil

                    machine.communicate.tap do |comm|

                        @last_shell_command_status = comm.execute(
                            command, {
                                :error_check => false,
                                :sudo        => opts[:as_root]
                            }
                        ) do |type,data|

                            if @vagrant_cucumber_debug
                                puts "[:#{type}] #{data.chomp}"
                            end

                            @last_shell_command_output[type] += data

                        end

                    end

                    if opts[:expect_nonzero]

                        if @last_shell_command_status != 0
                            raise "Expected command to return non-zero, got #{@last_shell_command_status}"
                        end

                    elsif opts.has_key?(:expect)

                        if @last_shell_command_status != opts[:expect]
                            raise "Expected command to return #{opts[:expect]}, got #{@last_shell_command_status}"
                        end

                    end

                end

            end


        end

    end

end

