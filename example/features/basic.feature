Feature: VM Running

    Scenario: Check we can run simple commands

        Given there is a running VM called "vm1"
        When I run the shell command `id`
        Then the stdout of that shell command should match /vagrant/
        And the stdout of that shell command should not match /root/
        And the stderr of that shell command should match /^$/


    Scenario: Check we can run commands as root

        Given there is a running VM called "vm1"
        When I run the shell command `id` as root
        Then the stdout of that shell command should match /root/
        And the stdout of that shell command should not match /vagrant/


    Scenario: Write a file so that we can check we're rolling back properly

        Given there is a running VM called "vm1"
        Then running the shell command `grep test /tmp/cucumber-written-file` should fail

        When I run the shell command `echo test > /tmp/cucumber-written-file`
        Then running the shell command `grep test /tmp/cucumber-written-file` should succeed

        When I roll back the VM called "vm1"
        Then running the shell command `grep test /tmp/cucumber-written-file` should fail


