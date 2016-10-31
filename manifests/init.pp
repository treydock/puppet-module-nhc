# == Class: nhc
#
# See README.md for more details.
#
class nhc (
  $ensure                     = 'present',

  # packages
  $package_ensure             = undef,
  $package_version            = '1.4.2',
  $package_release            = '1',
  $package_url                = undef,
  $install_from_repo          = undef,

  # NHC configuration
  $checks                     = $nhc::params::checks,
  $settings                   = $nhc::params::settings,
  $config_overrides           = $nhc::params::config_overrides,
  $detached_mode              = false,
  $detached_mode_fail_nodata  = false,
  $program_name               = $nhc::params::program_name,
  $conf_dir                   = $nhc::params::conf_dir,
  $conf_file                  = $nhc::params::conf_file,
  $include_dir                = $nhc::params::include_dir,
  $log_file                   = $nhc::params::log_file,
  $sysconfig_path             = $nhc::params::sysconfig_path,
  $manage_logrotate           = true,
  $log_rotate_every           = 'weekly',
  $custom_checks              = {},
) inherits nhc::params {

  validate_bool($detached_mode)
  validate_bool($detached_mode_fail_nodata)
  validate_bool($manage_logrotate)

  if ! is_hash($checks) and ! is_array($checks) {
    fail("Module ${module_name}: checks parameter must be a Hash or an Array.")
  }

  validate_hash($settings)
  validate_hash($config_overrides)

  case $ensure {
    'present': {
      if $install_from_repo {
        $_package_ensure  = pick($package_ensure, "${package_version}-${package_release}.el${::operatingsystemmajrelease}")
      } else {
        $_package_ensure  = pick($package_ensure, 'installed')
      }
      $directory_ensure = 'directory'
      $_directory_force = undef
      $file_ensure      = 'file'
    }
    'absent': {
      $_package_ensure  = 'absent'
      $directory_ensure = 'absent'
      $_directory_force = true
      $file_ensure      = 'absent'
    }
    default: {
      fail("Module ${module_name}: ensure parameter must be 'present' or 'absent', ${ensure} given.")
    }
  }

  if $install_from_repo {
    $_package_require             = Yumrepo[$install_from_repo]
    $_package_source              = undef
    $_package_provider            = 'yum'
  } else {
    $_package_require             = undef
    $_package_url_version         = regsubst($nhc::params::package_url, '%VERSION%', $package_version, 'G')
    $_package_url_version_release = regsubst($_package_url_version, '%RELEASE%', $package_release)
    $_package_source              = pick($package_url, $_package_url_version_release)
    $_package_provider            = 'rpm'
  }

  $default_configs = {
    'CONFDIR'                   => $conf_dir,
    'CONFFILE'                  => $conf_file,
    'DETACHED_MODE'             => $detached_mode,
    'DETACHED_MODE_FAIL_NODATA' => $detached_mode_fail_nodata,
    'INCDIR'                    => $include_dir,
    'NAME'                      => $program_name,
  }

  $configs = merge($default_configs, $config_overrides)

  include nhc::install
  include nhc::config
  
  anchor { 'nhc::start': }->
  Class['nhc::install']->
  Class['nhc::config']->
  anchor { 'nhc::end': }

  create_resources('nhc::custom_check', $custom_checks)

}
