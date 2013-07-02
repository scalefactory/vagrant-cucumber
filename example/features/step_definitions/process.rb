# Cucumber step definitions are defined like function definitions, and start 
# with a preposition or adverb (Given, When, Then, And, But).
# 
# The regular expression defined will be matched against steps in the feature
# files when cucumber runs.  The matched groups in the regex will be passed
# in order as variables to the block.  In this case, the three groups are 
# assigned to "condition", "process_name" and "vmre"
#
# More information on step definitions can be found at
# https://github.com/cucumber/cucumber/wiki/Step-Definitions

Then /there should(| not) be a process called "([^"]*)" running(#{VMRE})$/ do |condition, process_name, vmre|

    # First, we work out what virtual machine we're going to be dealing with
    # in this step.  The VMRE variable in the regex above is defined by
    # vagrant-cucumber to match various English-language ways in which we
    # might refer to a vagrant box:
    #
    #  String matched                  VM identified
    #  -------------------------------------------------------------------
    #  ''                              Last referenced
    #  'on the last VM'                Last referenced
    #  'on the VM "<vmname>"'          Named <vmname>
    #  'on the VM called "<vmname>"'   Named <vmname>
    #
    #  The call to vagrant_glue.identified_vm returns a Vagrant::Machine
    #  object to the relevant VM.

    machine = vagrant_glue.identified_vm(vmre)


    # Now we use the machine's communication interface (probably ssh, though
    # this is provider-dependent) to execute a shell command inside the VM.

    machine.communicate.tap do |comm|

        rv = comm.execute( 
            "pidof #{process_name}", { 
                :error_check => false, # stop vagrant throwing an exception
            }                          # if the command returns non-zero
            
        ) do |type,data|

            # Execute takes a block, which is yielded to whenever there's
            # output on stdout or stderr.  We handle any output in this block.
            #
            # In this case, we'll put all output onto stdout, but only if
            # @vagrant_cucumber_debug has been set.  This class variable will
            # be set to true in the Before hook defined in 
            # lib/vagrant-cucumber/step_definitions.rb

            if @vagrant_cucumber_debug
                puts "[:#{type}] #{data.chomp}"
            end

        end

        # Output the status from the command if we're in debugging mode
        if @vagrant_cucumber_debug
            puts "Exit status of pidof command: #{rv}"
        end

        # Cucumber steps are expected to exit cleanly if they worked ok, and
        # raise exceptions if they fail.  The following logic implements
        # the conditions in which we want to fail the step.

        if rv != 0 and condition == ''
            raise "There was no proces called #{process_name} running on #{machine.name}"
        end

        if rv == 0 and condition == ' not'
            raise "There was a process called #{process_name} running on #{machine.name}"
        end

    end

end
