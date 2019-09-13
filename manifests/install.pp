# private class
class nhc::install {
  assert_private()

  package { 'lbnl-nhc':
    ensure   => $::nhc::_package_ensure,
    name     => $::nhc::_package_name,
    source   => $::nhc::_package_source,
    provider => $::nhc::_package_provider,
    require  => $::nhc::_package_require,
  }

}
