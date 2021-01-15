Vagrant Cucumber
================

This is an open source project published by The Scale Factory.

We currently consider this project to be hibernating.

These are projects that we’re no longer prioritising, but which we keep ticking over for the benefit of the few customers we support who still use them.

:information_source: We’re not regularly patching these projects, or actively watching for issues or PRs. We’ll periodically make updates or respond to contributions if one of the team has some spare time to invest.

Description
-----------

This plugin allows Vagrant to run Cucumber features, and provides some glue
for working with Vagrant boxes within your Cucumber steps.

It was originally developed to help us test configuration management scripts,
and with the following workflow in mind:

 * Start one or more Vagrant boxes
 * Configure these boxes with some default state
 * Snapshot each box in this default state.
 * In each Cucumber scenario
    - Run config management tools inside the box to make configuration changes
    - Test that these changes produce the desired result
    - Roll the VM state back, ready for the next scenario


Requirements
------------

Since `0.1.x` this plugin requires a minimum Vagrant version of `1.8.4`.

The plugin requires the `cucumber` gem, but will install this itself if
required.

Vagrant Cucumber currently works only with the current Vagrant providers:

 * VirtualBox
 * VMWare Fusion (using the commercial VMWare plugin for Vagrant)


Installation
------------

Assuming you're running the packaged version of Vagrant, the easiest way to
install this plugin is via the published gem:

```
vagrant plugin install vagrant-cucumber
```

`vagrant-cucumber` will install a version of cucumber >= 2.4.0 under the
Ruby environment provided by Vagrant.


Usage
-----

This plugin adds a subcommand, `vagrant cucumber` - this simply wraps
the usual `cucumber` command line handler. Refer to the documentation for
cucumber for details, or use `vagrant cucumber -h` for a full list of
options.


Example
-------

The git source of the plugin includes a folder called "example", which contains
a Vagrantfile and features directory which demonstrates the plugin in action.

The Vagrantfile defines two basic VMs which will be used to run our tests.
It will work with either the Virtualbox or the VMWare Fusion provider.

Use `vagrant up` in that folder in order to start the default VM. (In the
current version of the plugin, VMs must be running before they can be used
in tests).  If you don't already have the standard `precise64` vagrant box, it
will be fetched from the Vagrant website.  If you prefer to use the VMWare
provider, add `--provider=vmware_fusion` to the commandline.

To run all the tests, run:

`vagrant cucumber`.

The tests are split between multiple feature files. You can run one feature
file at a time by specifying it on the commandline:

`vagrant cucumber features/basic.feature`

`basic.feature` demonstrates running basic shell commands inside the VM
both as the standard `vagrant` user, and as `root`.  It also contains a test to
show that snapshot rollback is working correctly.

`multivm.feature` shows how steps can reference different VMs.  For details
on how to write your own step definitions which can work on multiple VMs,
see the next section.

The test in `multivm.feature` also demonstrates use of cucumber tags.
The test scenario is preceded with the tag `@vagrant-cucumber-debug`. This
causes debug output to be emitted.

We also provide a `@norollback` tag, which prevents the VMs from being
rolled back at the end of the scenario.  This is useful for debugging.


Implementation Detail
---------------------

The best place to gain an understanding of the implementation of Cucumber steps
is in `example/features/step_definitions/process.rb`.  I've heavily
commented this in order to be a good working example.

`example/features/process.feature` uses these step definitions.

Other step definitions and hooks are defined in
`lib/vagrant-cucumber/step_definitions.rb`.


License
-------
`vagrant-cucumber` is licensed under the MIT license.
