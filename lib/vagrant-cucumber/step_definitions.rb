require 'to_regexp'

Given /^there is a running VM called "([^"]*)"$/ do |vmname|

    machine = vagrant_glue.get_vm( vmname )

    machine.action(:up)

    unless machine.provider.driver.has_snapshot?
        machine.action(:snapshot_take)
    end

end

When /^I roll back the VM called "([^"]*)"$/ do |vmname|

    machine = vagrant_glue.get_vm( vmname )
    vagrant_glue.vagrant_env.cli('snap', 'rollback', vmname )

end

Then /^(?:running|I run) the shell command `(.*)`(| as root)(#{VMRE})(?:|, it) should (succeed|fail)$/ do |command,as_root,vmre,condition|

    @last_shell_command_output = {
        :stdout => '',
        :stderr => '',
    }

    @last_shell_command_status = nil

    machine = vagrant_glue.identified_vm(vmre)
    machine.communicate.tap do |comm|

        @last_shell_command_status = comm.execute( 
            command, { 
                :error_check => false,
                :sudo        => as_root == ' as root',
            } 
        ) do |type,data|

            if @vagrant_cucumber_debug
                puts "[:#{type}] #{data.chomp}"
            end

            @last_shell_command_output[type] += data

        end 

    end

    if @last_shell_command_status == 0 and condition == 'fail'
        raise "Expected command to fail, but got 0 exit status"
    end

    if @last_shell_command_status != 0 and condition == 'succeed'
        raise "Expected command to succeed but got #{@last_shell_command_status} exit status"
    end

end

Then /^the (.+) of that shell command should(| not) match (\/.+\/)$/ do |stream,condition,re|

    stream.downcase!

    unless @last_shell_command_output.has_key?( stream.to_sym )
        raise "@last_shell_command_output structure has no #{stream}"
    end

    re_result = ( @last_shell_command_output[stream.to_sym] =~ re.to_regexp )
    re_matched = !re_result.nil?

    should_match = condition != ' not'

    if re_matched and !should_match
        raise "Regular expression matched, but shouldn't have"
    end

    if !re_matched and should_match
        raise "Regular expression didn't match, but should have"
    end

end

Before('@norollback') do |scenario|
    puts "Saw @norollback tag:"
    puts "  * Won't roll back snapshot at end of scenario"
    puts "  * Will roll back explicit snapshots in the scenario"
end



After('~@norollback') do |scenario|

    puts "Rolling back VM states"
    vagrant_glue.vagrant_env.cli('snap', 'rollback' )

end

After('@norollback') do |scenario|
    puts "Saw @norollback tag - not rolling back"
end

Before('@vagrant-cucumber-debug') do |scenario|
    puts "Enabling debugging for vagrant-cucumber scenarios"
    @vagrant_cucumber_debug = true
end
