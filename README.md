# puppet-module-warewulf

[![Build Status](https://travis-ci.org/treydock/puppet-module-warewulf.png)](https://travis-ci.org/treydock/puppet-module-warewulf)

####Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [TODO](#todo)
7. [Additional Information](#additional-information)

## Overview

This module currently manages the installation and configuration of Warewulf Node Health CHeck (NHC).

## Usage

### warewulf

Configure a host with NHC.

    class { 'warewulf': }

This is an example of using Hiera to define the default checks installed with NHC.

**Note**: The warewulf\_nhc\_checks Hiera variable can be used and is collected using the *hiera_array* lookup function.

    warewulf::nhc_checks:
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

    warewulf::nhc_checks:
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

## Reference

### Classes

#### Public classes

* `warewulf`: Installs and configures warewulf.

#### Private classes

* `warewulf::nhc`: Install and configure NHC.
* `warewulf::nhc::install`: Installs warewulf-nhc package.
* `warewulf::nhc::config`: Configures NHC.
* `warewulf::params`: Sets parameter defaults based on fact values.

### Parameters

#### warewulf

#####`foo`

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
