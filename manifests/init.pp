# == Class: warewulf
#
# See README.md for more details.
#
class warewulf (
  $ensure = 'present',

  # which subcomponents should be managed
  $nhc  = true,

  # repo
  $manage_repo      = true,
  $repo_ensure      = 'present',
  $repo_baseurl     = $warewulf::params::repo_baseurl,
  $repo_descr       = $warewulf::params::repo_descr,
  $repo_enabled     = '1',
  $repo_includepkgs = 'absent',

  # packages
  $nhc_package_ensure = 'present',

  # NHC configuration
  $nhc_checks                     = $warewulf::params::nhc_checks,
  $nhc_settings                   = $warewulf::params::nhc_settings,
  $nhc_config_overrides           = $warewulf::params::nhc_config_overrides,
  $nhc_detached_mode              = false,
  $nhc_detached_mode_fail_nodata  = false,
  $nhc_name                       = $warewulf::params::nhc_name,
  $nhc_conf_dir                   = $warewulf::params::nhc_conf_dir,
  $nhc_conf_file                  = $warewulf::params::nhc_conf_file,
  $nhc_include_dir                = $warewulf::params::nhc_include_dir,
  $nhc_log_file                   = $warewulf::params::nhc_log_file,
  $nhc_sysconfig_path             = $warewulf::params::nhc_sysconfig_path,
  $manage_nhc_logrotate           = true,
  $nhc_log_rotate_every           = 'weekly',
) inherits warewulf::params {

  validate_bool($nhc)
  validate_bool($manage_repo)
  validate_bool($nhc_detached_mode)
  validate_bool($nhc_detached_mode_fail_nodata)
  validate_bool($manage_nhc_logrotate)

  validate_array($nhc_checks)

  validate_hash($nhc_settings)
  validate_hash($nhc_config_overrides)

  case $ensure {
    'present': {
      $directory_ensure = 'directory'
      $file_ensure      = 'file'
    }
    'absent': {
      $directory_ensure = 'absent'
      $file_ensure      = 'absent'
    }
    default: {
      fail("Module ${module_name}: ensure parameter must be 'present' or 'absent', ${ensure} given.")
    }
  }

  $nhc_default_configs = {
    'CONFDIR'                   => $nhc_conf_dir,
    'CONFFILE'                  => $nhc_conf_file,
    'DETACHED_MODE'             => $nhc_detached_mode,
    'DETACHED_MODE_FAIL_NODATA' => $nhc_detached_mode_fail_nodata,
    'INCDIR'                    => $nhc_include_dir,
    'NAME'                      => $nhc_name,
  }

  $nhc_configs = merge($nhc_default_configs, $nhc_config_overrides)

  anchor { 'warewulf::start': }
  anchor { 'warewulf::end': }

  if $nhc {
    include warewulf::nhc

    Anchor['warewulf::start']->
    Class['warewulf::nhc']->
    Anchor['warewulf::end']
  }

}
