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
      ensure_packages($::nhc::source_dependencies)
      vcsrepo { '/usr/local/src/nhc':
        ensure   => 'latest',
        provider => 'git',
        source   => $::nhc::_install_source,
        revision => $::nhc::version,
        require  => Package[$::nhc::source_dependencies],
        notify   => Exec['install-nhc'],
      }
      $_autogen = '/usr/local/src/nhc/autogen.sh'
      $_configure = "./configure --prefix=/usr --sysconfdir=/etc --libexecdir=${nhc::libexec_dir}"
      $_install = 'make install'
      exec { 'install-nhc':
        path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        command     => "${_autogen} && ${_configure} && ${_install}",
        cwd         => '/usr/local/src/nhc',
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
