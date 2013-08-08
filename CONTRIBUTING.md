Contributing to vagrant-cucumber
================================

We welcome contributions to vagrant-cucumber, either to fix bugs or to add new features.

Patch workflow
--------------

 * Fork the project.
 * Create a branch for your changes.
 * Don't modify the version number or changelog - we'll do that on release.
 * Send a pull request


Working with the code
---------------------

We use Bundler to manage the development environment with the latest version of Vagrant and its dependencies.  Assuming you have Bundler installed, running ```bundle install``` in the project root will set the environment up for you.


Testing
-------

vagrant-cucumber is a reasonably thin glue layer, so doesn't need a whole lot of testing in its current incarnation.  As long as the published example features work, you can be confident your changes haven't broken anything.  To test this, run:

```
cd example
bundle exec vagrant cucumber
```

If you add any new behaviour to vagrant-cucumber, please add a feature file to
the ```example/``` folder which demonstrates how to use it.
