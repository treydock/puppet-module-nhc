# puppet-module-nhc

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/nhc.svg)](https://forge.puppetlabs.com/treydock/nhc)
[![Build Status](https://travis-ci.org/treydock/puppet-module-nhc.png)](https://travis-ci.org/treydock/puppet-module-nhc)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

This module manages the installation and configuration of [LBNL Node Health CHeck (NHC)](https://github.com/mej/nhc).

## Usage

### Class: nhc

Configure a host with NHC.

    include ::nhc

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

Defining settings that are for all hosts and a specific host:

    nhc::settings:
      DF_FLAGS: '"-Tkal -xgpfs -xfuse"'
      DFI_FLAGS: '"-Tkal -xgpfs -xfuse"'
      MAX_SYS_UID: '999'
      NHC_RM: 'slurm'
    nhc::settings_host:
      'c0001':
        PATH: '"$PATH:/some/other/sbin"'

This is an example of using a local yum repository to install NHC.

    nhc::install_method: repo
    nhc::repo_name: local-repo

This is an other example of using a custom package URL.

    nhc::install_method: package
    nhc::package_url: "https://example.com/lbnl-nhc-1.4.2-1.el7.custom.noarch.rpm"
    nhc::package_name: "lbnl-nhc-1.4.2-1.el7.custom.noarch.rpm"

It's possible to install from source (**this is default behavior for all but EL7 systems**):

    nhc::install_method: source

## Reference

[http://treydock.github.io/puppet-module-nhc/](http://treydock.github.io/puppet-module-nhc/)

## Limitations

This module has been tested on:

* CentOS/RedHat 7 x86_64
* CentOS/RedHat 8 x86_64
