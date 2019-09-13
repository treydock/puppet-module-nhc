# @summary Manage NHC configurations
#
# @example Define additional NHC configuration
#   nhc::conf { 'nhc-cron':
#     
#   }
# 
# @param ensure
# @param checks
# @param settings
# @param settings_host
# @param config_overrides
# @param detached_mode
# @param detached_mode_fail_nodata
# @param program_name
# @param conf_dir
# @param conf_file
# @param include_dir
# @param sysconfig_path
define nhc::conf (
  Enum['present', 'absent'] $ensure               = 'present',
  Variant[Hash, Array] $checks                    = [],
  Hash $settings                                  = {},
  Hash $settings_host                             = {},
  Hash $config_overrides                          = {},
  Boolean $detached_mode                          = false,
  Boolean $detached_mode_fail_nodata              = false,
  String $program_name                            = $name,
  Optional[Stdlib::Absolutepath] $conf_dir        = undef,
  Optional[Stdlib::Absolutepath] $conf_file       = undef,
  Optional[Stdlib::Absolutepath] $include_dir     = undef,
  Optional[Stdlib::Absolutepath] $sysconfig_path  = undef,
) {

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
    default: {}
  }

  include ::nhc

  $_conf_dir = pick($conf_dir, $::nhc::conf_dir)
  $_conf_file = pick($conf_file, "${_conf_dir}/${name}.conf")
  $_include_dir = pick($include_dir, $::nhc::include_dir)
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

  if $_conf_dir != $::nhc::conf_dir {
    file { $_conf_dir:
      ensure  => $directory_ensure,
      force   => $_directory_force,
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      require => Package['lbnl-nhc'],
    }
  }

  if $_conf_file != $::nhc::conf_file {
    file { $_conf_file:
      ensure  => $file_ensure,
      content => template('nhc/nhc.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => File[$_conf_dir],
    }
  }

  if $_include_dir != $::nhc::include_dir {
    file { $_include_dir:
      ensure  => $directory_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      require => Package['lbnl-nhc'],
    }
  }

  if $_sysconfig_path != $::nhc::sysconfig_path {
    file { $_sysconfig_path:
      ensure  => $file_ensure,
      content => template('nhc/sysconfig.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

}
