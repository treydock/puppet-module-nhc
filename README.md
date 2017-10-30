# puppet-module-nhc

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/nhc.svg)](https://forge.puppetlabs.com/treydock/nhc)
[![Build Status](https://travis-ci.org/treydock/puppet-module-nhc.png)](https://travis-ci.org/treydock/puppet-module-nhc)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [TODO](#todo)
7. [Additional Information](#additional-information)

## Overview

This module manages the installation and configuration of LBNL Node Health CHeck (NHC).

## Usage

### Class: nhc

Configure a host with NHC.

    class { 'nhc': }

This is an example of using Hiera to define the default checks installed with NHC.

    nhc::checks:
      - 'check_fs_mount_rw /tmp'
      - 'check_fs_mount_rw /'
      - 'check_fs_mount_rw /dev/pts '/(none|devpts)/' devpts'
      - 'check_ps_daemon sshd root'
      - 'check_ps_daemon provisiond root'
      - 'check_ps_daemon wulfd root'
      - 'check_ps_unauth_users log syslog'
      - 'check_ps_userproc_lineage log syslog'
      - 'check_ps_kswapd 1800000 100 log syslog'
      - 'check_hw_cpuinfo 2 8 8'
      - 'check_hw_physmem 1024 1073741824'
      - 'check_hw_swap 1 1073741824'
      - 'check_hw_mem 1024 1073741824'
      - 'check_hw_physmem_free 1'
      - 'check_hw_swap_free 1'
      - 'check_hw_mem_free 1'
      - 'check_hw_ib 40'
      - 'check_hw_gm myri0'
      - 'check_hw_eth eth1'

A Hash can also be used to define checks

    nhc::checks:
      '*':
        - 'check_fs_mount_rw /tmp'
        - 'check_fs_mount_rw /'
        - 'check_fs_mount_rw /dev/pts '/(none|devpts)/' devpts'
      'foo.baz':
        - 'check_ps_daemon sshd root'
        - 'check_ps_daemon provisiond root'
        - 'check_ps_daemon wulfd root'
        - 'check_ps_unauth_users log syslog'
        - 'check_ps_userproc_lineage log syslog'
        - 'check_ps_kswapd 1800000 100 log syslog'
      'foo.bar':
        - 'check_hw_cpuinfo 2 8 8'
        - 'check_hw_physmem 1024 1073741824'
        - 'check_hw_swap 1 1073741824'
        - 'check_hw_mem 1024 1073741824'
        - 'check_hw_physmem_free 1'
        - 'check_hw_swap_free 1'
        - 'check_hw_mem_free 1'
        - 'check_hw_ib 40'
        - 'check_hw_gm myri0'
        - 'check_hw_eth eth1'

This is an example of using a local yum repository to install NHC.

    nhc::install_from_repo: 'local-repo'

This is an other example of using a custom package url.

    nhc::package_url: "http://warewulf.lbl.gov/downloads/repo/rhel6/warewulf-nhc-1.4.1-1.el6.noarch.rpm"
    nhc::package_name: "warewulf-nhc-1.4.1-1.el6.noarch"

### Define: nhc::conf

Below is an example of using a custom nhc configuration for purposes of running NHC with alternate configuration.

    nhc::conf { 'nhc-cron':
      checks => # insert checks here, same as nhc class
    }

### Define nhc::custom_check

Define a custom check for use with NHC. The example below would add the file from `source` to `/etc/nhc/scripts/local_hw.nhc`.

    nhc::custom_check { 'local_hw':
      source => 'puppet:///modules/site_nhc/local_hw.nhc',
    }

## Reference

### Public Classes

#### Class: `nhc`:

Installs and configures NHC.

**Parameters**:

##### ensure

Presence state of NHC resources, valid values are `present` or `absent`, default is `present`.

##### package_ensure

Package ensure property.

Default when `install_from_repo` is defined: "${package_version}-${package_release}.el${::operatingsystemmajrelease}"`
Default when `install_from_repo` is undefined: `installed`

##### package_version

The package version. Default is `1.4.2`.

##### package_release

The package release. Default is `1`.

##### package_url

The URL to install package from. Only used when `install_from_repo` is not defined.  The value `%VERSION%` is substituted with `package_version` and `%RELEASE` is subsituted with `package_release`.

##### package_name

Package name.
Default when `install_from_repo` is defined: `lbnl-nhc`
Default when `install_from_repo` is undefined is `lbnl-nhc-%VERSION%-%RELEASE%.el${::operatingsystemmajrelease}.noarch` with same substitutions as `package_url`.

##### install\_from\_repo

The repo to install NHC from. The default value is `undef`, which installs NHC from `package_url`.

##### checks

Array or hash of checks. Default is `[]`.

##### settings

Array of settings that apply to all hosts. Default is `[]`.

##### settings_host

Hash of `host => [settings]`. Default is `{}`

##### config_overrides

Hash of configurations that go into the sysconfig file. Default is `{}`.

##### detached_mode

Boolean that enables DETACHED_MODE in sysconfig. Default is `false`

##### detached\_mode\_fail\_nodata

Boolean that enables DETACHED\_MODE\_FAIL\_NODATA in sysconfig. Default is `false`

##### program_name

The name of the NHC configuration. Defaults to `nhc`.

##### conf_dir

The configuration directory. Defaults to `/etc/nhc`.

##### conf_file

The configuration file. Defaults to `/etc/nhc/$name.conf`.

##### include_dir

The include directory path. Defaults to `/etc/nhc/scripts`.

##### sysconfig_path

Path to sysconfig file. Defaults to `/etc/sysconfig/$name`.

##### manage_logrotate

Boolean that determines if logrotate rules for NHC are managed.

##### log\_rotate\_every

Sets how often to rotate logs for NHC. Default is `weekly`.

##### custom_checks

Hash that defines `nhc::custom_check` defined types.

### Public Defined Types

#### Defined type: `nhc::conf`:

This allows alternative NHC configurations to be use. One possible use case would be a cron based NHC execution that has checks not normally used in the batch environment NHC.

**Parameters**:

##### ensure

Presence state of resource, valid values are `present` or `absent`, default is `present`.

##### checks

Array or hash of checks. Default is `[]`.

##### settings

Array of settings that apply to all hosts. Default is `[]`.

##### settings_host

Hash of `host => [settings]`. Default is `{}`

##### config_overrides

Hash of configurations that go into the sysconfig file. Default is `{}`.

##### detached_mode

Boolean that enables DETACHED_MODE in sysconfig. Default is `false`

##### detached\_mode\_fail\_nodata

Boolean that enables DETACHED\_MODE\_FAIL\_NODATA in sysconfig. Default is `false`

##### program_name

The name of the alternative NHC configuration. Defaults to name of defined type.

##### conf_dir

The configuration directory. Defaults to `/etc/nhc`.

##### conf_file

The configuration file. Defaults to `/etc/nhc/$name.conf`.

##### include_dir

The include directory path. Defaults to `/etc/nhc/scripts`.

##### sysconfig_path

Path to sysconfig file. Defaults to `/etc/sysconfig/$name`.

#### Defined type: `nhc::custom_check`

Defines a custom check to be added to the NHC include directory.

**Parameters**:

##### name

The name of this custom check. The `name` value is used to set path of the `nhc` suffixed file.

##### source

The source path of the custom check.

## Limitations

This module has been tested on:

* CentOS/RedHat 6 x86_64
* CentOS/RedHat 7 x86_64

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

## TODO

## Further Information

*
