
Given /^there is a running VM called "([^"]*)"$/ do |vmname|

    machine = vagrant_glue.get_vm( vmname )
    machine.action(:up)

    vagrant_glue.vagrant_env.cli('sandbox', 'on', vmname )

end

When /^I run some test(#{VMRE})$/ do |vmre|
  
    machine = vagrant_glue.identified_vm(vmre)

end

After('~@norollback') do |scenario|

    puts "Rolling back VM states"
    vagrant_glue.vagrant_env.cli('sandbox', 'rollback' )

end

After('@norollback') do |scenario|
        puts "Saw @norollback tag - not rolling back"
end
