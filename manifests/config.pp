# private class
class nhc::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { '/etc/nhc':
    ensure => $nhc::directory_ensure,
    path   => $nhc::conf_dir,
    force  => $nhc::_directory_force,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/etc/nhc/nhc.conf':
    ensure  => $nhc::file_ensure,
    path    => $nhc::conf_file,
    content => template('nhc/nhc.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/nhc'],
  }

  file { '/etc/nhc/scripts':
    ensure  => $nhc::directory_ensure,
    path    => $nhc::include_dir,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    require => File['/etc/nhc'],
  }

  file { '/etc/sysconfig/nhc':
    ensure  => $nhc::file_ensure,
    path    => $nhc::sysconfig_path,
    content => template('nhc/sysconfig.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $nhc::manage_logrotate {
    logrotate::rule { 'nhc':
      ensure       => $nhc::ensure,
      path         => $nhc::log_file,
      missingok    => true,
      ifempty      => false,
      rotate_every => $nhc::log_rotate_every,
    }
  }
}
