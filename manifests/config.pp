# private class
class nhc::config {
  assert_private()

  # Define template variables here so that nhc::conf can reuse template
  $configs        = $nhc::configs
  $settings       = $nhc::settings
  $settings_host  = $nhc::settings_host
  $checks         = $nhc::checks

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

  file { '/var/run/nhc':
    ensure => $directory_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { $nhc::sysconfig_path:
    ensure  => $nhc::file_ensure,
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
