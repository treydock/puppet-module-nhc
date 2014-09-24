# private class
class warewulf::nhc::install {

  package { 'warewulf-nhc':
    ensure  => $warewulf::nhc_package_ensure,
    name    => 'warewulf-nhc',
  }

}
