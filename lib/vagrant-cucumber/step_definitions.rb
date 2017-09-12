require 'to_regexp'

def push_snapshot(vmname)
    case machine_provider(vmname)
    when :libvirt
        vagrant_glue.vagrant_env.cli('sandbox', 'on', vmname)
        vagrant_glue.vagrant_env.cli('sandbox', 'commit', vmname)
    when :aws
        return
    when :no_machines
        return
    else
        vagrant_glue.vagrant_env.cli('snapshot', 'push', vmname)
    end
rescue Vagrant::Errors::EnvironmentLockedError
    sleep 0.2
    retry
rescue LoadError
    raise 'Please install the `sahara` vagrant plugin.'
end

def snapshots_enabled?(vmname)
    case machine_provider(vmname)
    when :libvirt
        require 'sahara/session/factory'
        ses = Sahara::Session::Factory.create(vagrant_glue.get_vm(vmname))
        ses.is_snapshot_mode_on?
    when :aws
        false
    when :no_machines
        false
    else
        machine = vagrant_glue.get_vm(vmname)
        !machine.provider.capability(:snapshot_list).empty?
    end
end

def machine_provider(vmname)
    if vmname.nil?
        return :no_machines if vagrant_glue.vagrant_env.active_machines.empty?
        vagrant_glue.vagrant_env.active_machines[0][1]
    else
        vagrant_glue.get_vm(vmname).provider_name
    end
end

def pop_snapshot(vmname = nil)
    args =  case machine_provider(vmname)
            when :libvirt
                %w(sandbox rollback)
            when :aws
                return
            else
                %w(snapshot pop --no-provision --no-delete)
            end
    args << vmname unless vmname.nil?

    vagrant_glue.vagrant_env.cli(*args)
rescue Vagrant::Errors::EnvironmentLockedError
    sleep 0.2
    retry
end

Given /^there is a running VM called "([^"]*)"$/ do |vmname|
    machine = vagrant_glue.get_vm(vmname)
    machine.action(:up)
    push_snapshot(vmname) unless snapshots_enabled?(vmname)
end

When /^I roll back the VM called "([^"]*)"$/ do |vmname|
    _machine = vagrant_glue.get_vm(vmname)

    pop_snapshot(vmname)
end

Then /^(?:running|I run) the shell command `(.*)`(| as root)(#{VMRE})(?:|, it) should (succeed|fail)$/ do |command, as_root, vmre, condition|
    options = {
        as_root:         (as_root == ' as root'),
        expect_non_zero: (condition == 'fail')
    }

    options[:expect] = 0 if condition == 'succeed'

    vagrant_glue.execute_on_vm(
        command,
        vagrant_glue.identified_vm(vmre),
        options
    )
end

Then /^(?:running|I run) the shell command `(.*)`(| as root)(#{VMRE})$/ do |command, as_root, vmre|
    options = {
        machine: vagrant_glue.identified_vm(vmre),
        as_root: (as_root == ' as root')
    }

    vagrant_glue.execute_on_vm(
        command,
        vagrant_glue.identified_vm(vmre),
        options
    )
end

Then /^the (.+) of that shell command should(| not) match (\/.+\/)$/ do |stream, condition, re|
    stream.downcase!

    unless vagrant_glue.last_shell_command_output.key?(stream.to_sym)
        raise "vagrant_glue.last_shell_command_output structure has no #{stream}"
    end

    re_result = (
        vagrant_glue.last_shell_command_output[stream.to_sym] =~ re.to_regexp
    )

    re_matched = !re_result.nil?

    should_match = condition != ' not'

    if re_matched && !should_match
        raise "Regular expression matched, but shouldn't have"
    end

    if !re_matched && should_match
        raise "Regular expression didn't match, but should have"
    end
end

Before('@norollback') do |_scenario|
    puts 'Saw @norollback tag:'
    puts "  * Won't roll back snapshot at end of scenario"
    puts '  * Will roll back explicit snapshots in the scenario'
end

After('~@norollback') do |_scenario|
    puts 'Rolling back VM states'
    pop_snapshot
end

After('@norollback') do |_scenario|
    puts 'Saw @norollback tag - not rolling back'
end

Before('@vagrant-cucumber-debug') do |_scenario|
    puts 'Enabling debugging for vagrant-cucumber scenarios'
    @vagrant_cucumber_debug = true
end
