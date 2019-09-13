# private class
class nhc::install {
  assert_private()

  if $::nhc::install_from_repo {
    package { 'lbnl-nhc':
      ensure  => $::nhc::_package_ensure,
      name    => $::nhc::_package_name,
      require => $::nhc::_package_require,
    }
  } else {
    yum::install { $::nhc::_package_name:
      ensure  => $::nhc::ensure,
      source  => $::nhc::_package_source,
      require => $::nhc::_package_require,
    }
  }

}
