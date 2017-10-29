# puppet-module-nhc

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/nhc.svg)](https://forge.puppetlabs.com/treydock/nhc)
[![Build Status](https://travis-ci.org/treydock/puppet-module-nhc.png)](https://travis-ci.org/treydock/puppet-module-nhc)

####Table of Contents

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

**Note**: The `nhc_checks` Hiera key can be used and is collected using the *hiera_array* lookup function.  If `nhc_checks` in present in Hiera, it is used as the default value for `checks`.

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

    nhc::install_from_repo: 'foo-repo'

This is an other example of using a custom package url.

    nhc::package_url: "http://warewulf.lbl.gov/downloads/repo/rhel6/warewulf-nhc-1.4.1-1.el6.noarch.rpm"
    nhc::package_name: "warewulf-nhc-1.4.1-1.el6.noarch"

## Reference

### Public Classes

#### Class: `nhc`:

Installs and configures NHC.  Default values in Hiera format are below.

$::osfamily == 'RedHat'

    nhc::ensure: 'present'
    nhc::package_ensure: undef
    nhc::package_version: '1.4.2'
    nhc::package_release: '1'
    nhc::package_url: "https://github.com/mej/nhc/releases/download/%VERSION%/lbnl-nhc-%VERSION%-%RELEASE%.el%{::operatingsystemmajrelease}.noarch.rpm"
    nhc::package_name: "lbnl-nhc-%VERSION%-%RELEASE%.el${::operatingsystemmajrelease}.noarch"
    nhc::install_from_repo: undef
    nhc::checks: []
    nhc::settings: {}
    nhc::config_overrides: {}
    nhc::detached_mode: false
    nhc::detached_mode_fail_nodata: false
    nhc::program_name: 'nhc'
    nhc::conf_dir: '/etc/nhc'
    nhc::conf_file: '/etc/nhc/nhc.conf'
    nhc::include_dir: '/etc/nhc/scripts'
    nhc::log_file: '/var/log/nhc.log'
    nhc::sysconfig_path: '/etc/sysconfig/nhc'
    nhc::manage_logrotate: true
    nhc::log_rotate_every: 'weekly'


## Limitations

This module has been tested on:

* CentOS 6 x86_64

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
