# @summary Manage Node Health Check (NHC)
#
# @example
#   include ::nhc
#
# @param ensure
# @param install_method
# @param package_ensure
# @param version
# @param package_release
# @param install_source
# @param package_name
# @param repo_name
# @param source_dependencies
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
# @param log_file
# @param sysconfig_path
# @param manage_logrotate
# @param log_rotate_every
# @param custom_checks
class nhc (
  Enum['present', 'absent'] $ensure   = 'present',

  # packages
  Enum['repo','package','source'] $install_method = 'package',
  Optional[String] $package_ensure      = undef,
  Optional[String] $version     = '1.4.2',
  Optional[String] $package_release     = '1',
  Optional[Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl]]
    $install_source                     = undef,
  Optional[String] $package_name        = undef,
  Optional[String] $repo_name           = undef,
  Array $source_dependencies            = ['automake','make'],

  # NHC configuration
  Variant[Hash, Array] $checks          = [],
  Hash $settings                        = {},
  Hash $settings_host                   = {},
  Hash $config_overrides                = {},
  Boolean $detached_mode                = false,
  Boolean $detached_mode_fail_nodata    = false,
  String $program_name                  = 'nhc',
  Stdlib::Absolutepath $conf_dir        = '/etc/nhc',
  Stdlib::Absolutepath $conf_file       = '/etc/nhc/nhc.conf',
  Stdlib::Absolutepath $include_dir     = '/etc/nhc/scripts',
  Stdlib::Absolutepath $log_file        = '/var/log/nhc.log',
  Stdlib::Absolutepath $sysconfig_path  = '/etc/sysconfig/nhc',
  Boolean $manage_logrotate             = true,
  String $log_rotate_every              = 'weekly',
  Hash $custom_checks                   = {},
) {

  $osfamily = dig($facts, 'os', 'family')
  if ! ($osfamily in ['RedHat']) {
    fail("Unsupported osfamily: ${osfamily}, module ${module_name} only supports RedHat")
  }

  case $ensure {
    'present': {
      if $install_method == 'repo' {
        $_package_ensure  = pick($package_ensure, "${version}-${package_release}.el${facts['os']['release']['major']}")
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

  if $install_method == 'repo' {
    if $repo_name {
      $_package_require = Yumrepo[$repo_name]
    } else {
      $_package_require = undef
    }
    $_install_source              = undef
    $_package_name                = pick($package_name, 'lbnl-nhc')
  } elsif $install_method == 'package' {
    $_default_package_name   = "lbnl-nhc-${version}-${package_release}.el${facts['os']['release']['major']}.noarch"
    $_default_install_source = "https://github.com/mej/nhc/releases/download/${version}/${_default_package_name}.rpm"
    $_package_require             = undef
    $_install_source = pick($install_source, $_default_install_source)
    $_package_name = pick($package_name, $_default_package_name)
  } else {
    $_install_source = pick($install_source, 'https://github.com/mej/nhc.git')
  }

  $default_configs = {
    'CONFDIR'                   => $conf_dir,
    'CONFFILE'                  => $conf_file,
    'DETACHED_MODE'             => $detached_mode,
    'DETACHED_MODE_FAIL_NODATA' => $detached_mode_fail_nodata,
    'INCDIR'                    => $include_dir,
    'LOGFILE'                   => $log_file,
    'NAME'                      => $program_name,
  }

  $configs = merge($default_configs, $config_overrides)

  contain ::nhc::install
  contain ::nhc::config

  Class['nhc::install']
  -> Class['nhc::config']

  $custom_checks.each |$name, $params| {
    ::nhc::custom_check { $name: * => $params }
  }

}
