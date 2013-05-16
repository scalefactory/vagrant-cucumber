Feature: VM Running

    Scenario: Basic start of a VM
        Given there is a running VM called "default"
        When I run some test
