Feature: Check to see if processes are running in the VM

    Scenario: Check that init is running
        Given there is a running VM called "vm1"
        Then there should be a process called "init" running

    Scenario: Check that non-existant process check also works
        Given there is a running VM called "vm1"
        Then there should not be a process called "i-dont-exist" running
