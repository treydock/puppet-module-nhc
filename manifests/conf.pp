# @summary Manage NHC configurations
#
# @example Define additional NHC configuration
#   nhc::conf { 'nhc-cron':
#     settings          => { 'NHC_RM' => 'slurm' },
#     settings_host     => { 'c0001' => { 'FOO' => 'bar' }},
#     checks            => { '*' => ['check_fs_free /tmp 10%'] },
#     config_overrides  => { 'HOSTNAME' => '"$HOSTNAME_S"' },
#   }
# 
# @param ensure
#   State of nhc::conf
# @param checks
#   Checks to add to the configuration file
# @param settings
#   Settings to add to the configuration file
# @param settings_host
#   Settings specific to a hosts to add to the configuration file
# @param config_overrides
#   Overrides for configuration in /etc/sysconfig/$name
# @param detached_mode
#   Value for DETACHED_MODE
# @param detached_mode_fail_nodata
#   Value for DETACHED_MODE_FAIL_NODATA
# @param program_name
#   Value for NAME
# @param conf_dir
#   Path to NHC configuration directry. Defaults to `/etc/nhc`
# @param conf_file
#   Path for this configuration file. Defaults to `/etc/nhc/$name.conf`
# @param include_dir
#   Path to directory containing NHC checks. Defaults to `/etc/nhc/scripts`
# @param sysconfig_path
#   Path to sysconfig file. Defaults to `/etc/sysconfig/$name`
# @param log_file
#   Path to log file. Defaults to `/var/log/$name.log`
#
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
  Optional[Stdlib::Absolutepath] $log_file        = undef,
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
  $_log_file = pick($log_file, "/var/log/${name}.log")

  $default_configs = {
    'CONFDIR'                   => $_conf_dir,
    'CONFFILE'                  => $_conf_file,
    'DETACHED_MODE'             => $detached_mode,
    'DETACHED_MODE_FAIL_NODATA' => $detached_mode_fail_nodata,
    'INCDIR'                    => $_include_dir,
    'LOGFILE'                   => $_log_file,
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
