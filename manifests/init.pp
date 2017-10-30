# == Class: nhc
#
# See README.md for more details.
#
class nhc (
  Enum['present', 'absent'] $ensure   = 'present',

  # packages
  Optional[String] $package_ensure      = undef,
  Optional[String] $package_version     = '1.4.2',
  Optional[String] $package_release     = '1',
  Optional[Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl]]
    $package_url                        = undef,
  Optional[String] $package_name        = undef,
  Optional[String] $install_from_repo   = undef,

  # NHC configuration
  Variant[Hash, Array] $checks          = [],
  Hash $settings                        = {},
  Hash $settings_host                   = {},
  Hash $config_overrides                = {},
  Boolean $detached_mode                = false,
  Boolean $detached_mode_fail_nodata    = false,
  String $program_name                  = $nhc::params::program_name,
  Stdlib::Absolutepath $conf_dir        = $nhc::params::conf_dir,
  Stdlib::Absolutepath $conf_file       = $nhc::params::conf_file,
  Stdlib::Absolutepath $include_dir     = $nhc::params::include_dir,
  Stdlib::Absolutepath $log_file        = $nhc::params::log_file,
  Stdlib::Absolutepath $sysconfig_path  = $nhc::params::sysconfig_path,
  Boolean $manage_logrotate             = true,
  String $log_rotate_every              = 'weekly',
  Hash $custom_checks                   = {},
) inherits nhc::params {

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
    default: {}
  }

  if $install_from_repo {
    $_package_require             = Yumrepo[$install_from_repo]
    $_package_source              = undef
    $_package_name                = 'lbnl-nhc'
    $_package_provider            = 'yum'
  } else {
    $_package_require             = undef
    $_package_url_version         = regsubst($nhc::params::package_url, '%VERSION%', $package_version, 'G')
    $_package_url_version_release = regsubst($_package_url_version, '%RELEASE%', $package_release)
    $_package_source              = pick($package_url, $_package_url_version_release)
    $_package_name_version        = regsubst($nhc::params::package_name, '%VERSION%', $package_version, 'G')
    $_package_name_version_release= regsubst($_package_name_version, '%RELEASE%', $package_release)
    $_package_name                = pick($package_name, $_package_name_version_release)
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

  include ::nhc::install
  include ::nhc::config

  anchor { 'nhc::start': }
  -> Class['nhc::install']
  -> Class['nhc::config']
  -> anchor { 'nhc::end': }

  create_resources('nhc::custom_check', $custom_checks)

}
