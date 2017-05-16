# private class
class nhc::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $nhc::_package_name:
    ensure   => $nhc::_package_ensure,
    source   => $nhc::_package_source,
    provider => $nhc::_package_provider,
    require  => $nhc::_package_require,
  }

}
