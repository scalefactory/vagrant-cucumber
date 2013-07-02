Feature: Testing on multiple VMs

    @vagrant-cucumber-debug
    Scenario: Check we can run simple commands on multiple VMs

        Given there is a running VM called "vm1"
        And there is a running VM called "vm2"

        # The following four steps are equivalent
        Then running the shell command `hostname` on the VM called "vm1" should succeed
        Then running the shell command `hostname` on the VM "vm1" should succeed
        And running the shell command `hostname` on the last VM should succeed
        And running the shell command `hostname` should succeed

        And running the shell command `hostname` on the VM "vm2" should succeed



