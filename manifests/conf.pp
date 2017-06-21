# == Define: nhc::conf
#
define nhc::conf (
  $ensure                     = 'present',
  $checks                     = [],
  $settings                   = {},
  $config_overrides           = {},
  $detached_mode              = false,
  $detached_mode_fail_nodata  = false,
  $program_name               = $name,
  $conf_dir                   = undef,
  $conf_file                  = undef,
  $include_dir                = undef,
  $sysconfig_path             = undef,
) {

  validate_bool($detached_mode)
  validate_bool($detached_mode_fail_nodata)

  if ! is_hash($checks) and ! is_array($checks) {
    fail("Module ${module_name}: checks parameter must be a Hash or an Array.")
  }

  validate_hash($settings)
  validate_hash($config_overrides)

  case $ensure {
    'present': {
      $directory_ensure = 'directory'
      $_directory_force = undef
      $file_ensure      = 'file'
    }
    'absent': {
      $directory_ensure = 'absent'
      $_directory_force = true
      $file_ensure      = 'absent'
    }
    default: {
      fail("Define nhc::conf: ensure parameter must be 'present' or 'absent', ${ensure} given.")
    }
  }

  require '::nhc'

  $_conf_dir = pick($conf_dir, $nhc::conf_dir)
  $_conf_file = pick($conf_file, "${_conf_dir}/${name}.conf")
  $_include_dir = pick($include_dir, $nhc::include_dir)
  $_sysconfig_path = pick($sysconfig_path, "/etc/sysconfig/${name}")

  $default_configs = {
    'CONFDIR'                   => $_conf_dir,
    'CONFFILE'                  => $_conf_file,
    'DETACHED_MODE'             => $detached_mode,
    'DETACHED_MODE_FAIL_NODATA' => $detached_mode_fail_nodata,
    'INCDIR'                    => $_include_dir,
    'NAME'                      => $program_name,
  }

  $configs = merge($default_configs, $config_overrides)

  if $_conf_dir != $nhc::conf_dir {
    file { $_conf_dir:
      ensure => $directory_ensure,
      force  => $_directory_force,
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
    }
  }

  if $_conf_file != $nhc::conf_file {
    file { $_conf_file:
      ensure  => $file_ensure,
      content => template('nhc/nhc.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  if $_include_dir != $nhc::include_dir {
    file { $_include_dir:
      ensure => $directory_ensure,
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
    }
  }

  if $_sysconfig_path != $nhc::sysconfig_path {
    file { $_sysconfig_path:
      ensure  => $file_ensure,
      content => template('nhc/sysconfig.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

}
