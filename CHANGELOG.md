# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v7.0.1](https://github.com/treydock/puppet-module-nhc/tree/v7.0.1) (2026-02-17)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/v7.0.0...v7.0.1)

### Fixed

- nhc 1.5 requires /var/run/nhc [\#28](https://github.com/treydock/puppet-module-nhc/pull/28) ([pedmon](https://github.com/pedmon))

## [v7.0.0](https://github.com/treydock/puppet-module-nhc/tree/v7.0.0) (2026-02-12)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/v6.0.0...v7.0.0)

### Changed

- Drop Ubuntu 20.04 support [\#32](https://github.com/treydock/puppet-module-nhc/pull/32) ([treydock](https://github.com/treydock))
- Drop Puppet 7 support [\#30](https://github.com/treydock/puppet-module-nhc/pull/30) ([treydock](https://github.com/treydock))

### Added

- Add support for EL10 and Ubutnu 24.04 [\#33](https://github.com/treydock/puppet-module-nhc/pull/33) ([treydock](https://github.com/treydock))
- Support vcsrepo 7.x [\#31](https://github.com/treydock/puppet-module-nhc/pull/31) ([treydock](https://github.com/treydock))
- Allow logrotate \<9 [\#29](https://github.com/treydock/puppet-module-nhc/pull/29) ([optiz0r](https://github.com/optiz0r))

## [v6.0.0](https://github.com/treydock/puppet-module-nhc/tree/v6.0.0) (2024-10-14)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/v5.0.0...v6.0.0)

### Changed

- Major updates - READ DESCRIPTION [\#27](https://github.com/treydock/puppet-module-nhc/pull/27) ([treydock](https://github.com/treydock))

## [v5.0.0](https://github.com/treydock/puppet-module-nhc/tree/v5.0.0) (2023-08-21)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/v4.0.0...v5.0.0)

### Changed

- BREAKING: Major updates - see description [\#25](https://github.com/treydock/puppet-module-nhc/pull/25) ([treydock](https://github.com/treydock))

### Added

- Support EL9 [\#26](https://github.com/treydock/puppet-module-nhc/pull/26) ([treydock](https://github.com/treydock))

## [v4.0.0](https://github.com/treydock/puppet-module-nhc/tree/v4.0.0) (2022-04-13)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/v3.1.0...v4.0.0)

### Changed

- Bump default version to 1.4.3 and default to package install on EL8 [\#24](https://github.com/treydock/puppet-module-nhc/pull/24) ([treydock](https://github.com/treydock))

### Added

- Replace CentOS 8 with Rocky 8 [\#23](https://github.com/treydock/puppet-module-nhc/pull/23) ([treydock](https://github.com/treydock))

## [v3.1.0](https://github.com/treydock/puppet-module-nhc/tree/v3.1.0) (2021-10-04)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/v3.0.0...v3.1.0)

### Added

- Support newer logrotate and stdlib modules [\#22](https://github.com/treydock/puppet-module-nhc/pull/22) ([treydock](https://github.com/treydock))

## [v3.0.0](https://github.com/treydock/puppet-module-nhc/tree/v3.0.0) (2021-09-24)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/v2.0.3...v3.0.0)

### Changed

- Update module dependencies and version ranges for OS and Puppet [\#18](https://github.com/treydock/puppet-module-nhc/pull/18) ([treydock](https://github.com/treydock))
- Remove EL6 support, Remove Puppet 5 support, Add Puppet 7 support, Update module dependency ranges [\#17](https://github.com/treydock/puppet-module-nhc/pull/17) ([treydock](https://github.com/treydock))

### Added

- Improved source install handling [\#21](https://github.com/treydock/puppet-module-nhc/pull/21) ([treydock](https://github.com/treydock))
- Support Debian and Ubuntu - default to source install except for EL7 [\#20](https://github.com/treydock/puppet-module-nhc/pull/20) ([treydock](https://github.com/treydock))
- Support EL8 [\#19](https://github.com/treydock/puppet-module-nhc/pull/19) ([treydock](https://github.com/treydock))

## [v2.0.3](https://github.com/treydock/puppet-module-nhc/tree/v2.0.3) (2019-12-16)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/v2.0.2...v2.0.3)

### Fixed

- Pdk update [\#15](https://github.com/treydock/puppet-module-nhc/pull/15) ([treydock](https://github.com/treydock))

## [v2.0.2](https://github.com/treydock/puppet-module-nhc/tree/v2.0.2) (2019-10-10)

[Full Changelog](https://github.com/treydock/puppet-module-nhc/compare/v2.0.1...v2.0.2)

### Fixed

- Fix unit tests [\#14](https://github.com/treydock/puppet-module-nhc/pull/14) ([treydock](https://github.com/treydock))

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



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
