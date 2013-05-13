
Given /^there is a running VM called "([^"]*)"$/ do |vmname|

    machine = vagrant_glue.get_vm( vmname )
    machine.action(:up)

    # XXX should create new snapshot in current situation

end
