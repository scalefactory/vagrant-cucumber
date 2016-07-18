## WIP

 * Removed `vagrant-multiprovider-snap` dependency. Vagrant now has all
   required features.
 * Updates to various syntax in the code.
   * "New" style Ruby hashes (no hash rockets).
   * Removal of some deprecated methods (`Hash#has_key?`, etc)
 * Quick sweep with `rubocop` to fix some minor style issues.
 * Fixes to `README.md`, mostly removal of references to
   `vagrant-multiprovider-snap` with some markdown cleanups.

## 0.0.10 (May 6, 2015)

 * Fixed gemspec to constrain cucumber version

## 0.0.9 (May 6, 2015)

 * Fixes to ANSI escape code handling
 * Force cucumber gem version to pre-2.x

## 0.0.8 (April 29, 2014)

 * Fixed a bug in table formatting

## 0.0.7 (April 28, 2014)

 * Solves an edge case in environment creation

## 0.0.6 (March 11, 2014)

 * Support Vagrant 1.5 approach to plugin loading

## 0.0.5 (August 9, 2013)

 * Solve problem with missing i18n translations

## 0.0.4 (August 8, 2013)

 * Added missing license detail to Gem spec
 * Improve use of Given/When/Then in examples as per idiomatic Cucumber usage
 * Refactor to get shell runner helper into the glue and out of the step definitions
 * Added details on how to contribute to the project

 With thanks to Matt Wynne (@mattwynne) for feedback

## 0.0.3 (July 26, 2013)

 * Update dependencies for vagrant-multiprovider-snap

## 0.0.2 (July 4, 2013)

 * Clarify license position
 * Add correct dependency on to_regexp to the gem description.

## 0.0.1 (June 12, 2013)

Initial release - supports Virtualbox and VMWare Fusion
