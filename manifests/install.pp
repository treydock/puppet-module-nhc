# private class
class nhc::install {
  assert_private()

  if $::nhc::install_method == 'repo' {
    package { 'lbnl-nhc':
      ensure  => $::nhc::_package_ensure,
      name    => $::nhc::_package_name,
      require => $::nhc::_package_require,
    }
  } elsif $::nhc::install_method == 'package' {
    yum::install { $::nhc::_package_name:
      ensure  => $::nhc::ensure,
      source  => $::nhc::_install_source,
      require => $::nhc::_package_require,
    }
  } else {
    if $nhc::ensure == 'present' {
      $src_dir = '/usr/local/src/nhc'
      $sysconfdir = dirname($nhc::conf_dir)
      ensure_packages($::nhc::source_dependencies)
      vcsrepo { $src_dir:
        ensure   => 'latest',
        provider => 'git',
        source   => $::nhc::_install_source,
        revision => $::nhc::version,
        require  => Package[$::nhc::source_dependencies],
        notify   => Exec['install-nhc'],
      }
      file { "${src_dir}/puppet-install.sh":
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => join([
          '#!/bin/bash',
          "cd ${src_dir}",
          './autogen.sh',
          "./configure --prefix=/usr --sysconfdir=${sysconfdir} --libexecdir=${nhc::libexec_dir}",
          '[ $? -ne 0 ] && { rm -f $0; exit 1; }',
          'make install',
          '[ $? -ne 0 ] && { rm -f $0; exit 1; }',
          'exit 0',
          '',
        ], "\n"),
        notify  => Exec['install-nhc'],
        require => Vcsrepo[$src_dir],
      }
      exec { 'install-nhc':
        path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        command     => "${src_dir}/puppet-install.sh",
        cwd         => $src_dir,
        refreshonly => true,
      }
    } else {
      file { '/usr/local/src/nhc':
        ensure  => 'absent',
        recurse => true,
        force   => true,
        purge   => true,
      }
      file { "${nhc::libexec_dir}/nhc":
        ensure  => 'absent',
        recurse => true,
        force   => true,
        purge   => true,
      }
      file { '/usr/sbin/nhc':
        ensure => 'absent',
      }
    }
  }

}
