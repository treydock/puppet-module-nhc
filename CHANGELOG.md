# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v2.0.1](https://github.com/treydock/puppet-module-nhc/tree/v2.0.1) (2019-10-08)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/v2.0.0...v2.0.1)

### Fixed

- Remove LOGFILE from sysconfig files by default as it prevents log redirection to stdout [\#13](https://github.com/treydock/puppet-module-nhc/pull/13) ([treydock](https://github.com/treydock))

## [v2.0.0](https://github.com/treydock/puppet-module-nhc/tree/v2.0.0) (2019-09-27)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/1.1.0...v2.0.0)

### Changed

- Refactor how installs are handled and support source install [\#10](https://github.com/treydock/puppet-module-nhc/pull/10) ([treydock](https://github.com/treydock))

### Added

- Update module and puppet dependencies [\#12](https://github.com/treydock/puppet-module-nhc/pull/12) ([treydock](https://github.com/treydock))
- Improve docs [\#11](https://github.com/treydock/puppet-module-nhc/pull/11) ([treydock](https://github.com/treydock))
- Use yum module to install NHC RPM [\#9](https://github.com/treydock/puppet-module-nhc/pull/9) ([treydock](https://github.com/treydock))
- Set LOGFILE [\#8](https://github.com/treydock/puppet-module-nhc/pull/8) ([treydock](https://github.com/treydock))
- Improve [\#7](https://github.com/treydock/puppet-module-nhc/pull/7) ([treydock](https://github.com/treydock))
- Convert module to PDK [\#4](https://github.com/treydock/puppet-module-nhc/pull/4) ([treydock](https://github.com/treydock))

### Fixed

- Fix nhc\_version fact to not actually run on non-RedHat systems [\#3](https://github.com/treydock/puppet-module-nhc/pull/3) ([treydock](https://github.com/treydock))

## [1.1.0](https://github.com/treydock/puppet-module-nhc/tree/1.1.0) (2017-10-30)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/1.0.3...1.1.0)

## [1.0.3](https://github.com/treydock/puppet-module-nhc/tree/1.0.3) (2017-10-30)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/1.0.2...1.0.3)

## [1.0.2](https://github.com/treydock/puppet-module-nhc/tree/1.0.2) (2017-10-30)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/1.0.1...1.0.2)

## [1.0.1](https://github.com/treydock/puppet-module-nhc/tree/1.0.1) (2017-10-29)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/1.0.0...1.0.1)

## [1.0.0](https://github.com/treydock/puppet-module-nhc/tree/1.0.0) (2017-10-29)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/0.0.1...1.0.0)

## [0.0.1](https://github.com/treydock/puppet-module-nhc/tree/0.0.1) (2017-06-21)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/ba24628b4966a1ed52462f3a790ae3d16ab90f2c...0.0.1)

### Added

- package name is a parameter, fixing usage of the rpm provider [\#2](https://github.com/treydock/puppet-module-nhc/pull/2) ([rorist](https://github.com/rorist))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*