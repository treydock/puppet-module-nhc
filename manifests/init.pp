# @summary Manage Node Health Check (NHC)
#
# @example
#   include ::nhc
#
# @param ensure
#   State of NHC resources
# @param install_method
#   The method used to install NHC.
#   Using `repo` will require the `Yumrepo` resource if `repo_name` is defined.
# @param package_ensure
#   The ensure state of package if using `install_method` of `repo` or `package`.
# @param version
#   The version of NHC to install.
# @param package_release
#   The package release NHC to install. Not used if `install_method` is `source`.
# @param install_source
#   The source of install.
#   For `install_method` of `package` this is URL to package
#   For `install_method` of `source` this is git source URL
# @param package_name
#   Name of the NHC package, not used with `install_method` of `source`.
# @param repo_name
#   The repo name for NHC, only used with `install_method` of `repo`.
# @param source_dependencies
#   The package dependencies for source install.
# @param libexec_dir
#   Location for libexec directory, OS dependent.
# @param checks
#   NHC checks for nhc.conf
# @param settings
#   Settings to add to nhc.conf
# @param settings_host
#   Host specific settings for nhc.conf
# @param config_overrides
#   Settings to add to /etc/sysconfig/nhc
# @param detached_mode
#   Value for DETACHED_MODE
# @param detached_mode_fail_nodata
#   Value for DETACHED_MODE_FAIL_NODATA
# @param program_name
#   Value for NAME
# @param conf_dir
#   Path to NHC configuration directry
# @param conf_file
#   Path for this configuration file
# @param include_dir
#   Path to directory containing NHC checks
# @param log_file
#   Path to log file
# @param sysconfig_path
#   Path to sysconfig file
# @param manage_logrotate
#   Boolean that sets if logrotate resources should be managed
# @param log_rotate_every
#   Frequency of logrotation
# @param custom_checks
#   Hash passed to `nhc::custom_check`
#
class nhc (
  Enum['present', 'absent'] $ensure   = 'present',

  # packages
  Enum['repo','package','source'] $install_method = 'source',
  Optional[String] $package_ensure      = undef,
  String $version = '1.4.3',
  String $package_release = '1',
  Optional[Variant[Stdlib::HTTPUrl,Stdlib::HTTPSUrl]]
  $install_source                     = undef,
  Optional[String] $package_name        = undef,
  Optional[String] $repo_name           = undef,
  Array $source_dependencies            = ['automake','make'],
  Stdlib::Absolutepath $libexec_dir     = '/usr/libexec',

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
    'NAME'                      => $program_name,
  }

  $configs = merge($default_configs, $config_overrides)

  contain nhc::install
  contain nhc::config

  Class['nhc::install']
  -> Class['nhc::config']

  $custom_checks.each |$name, $params| {
    nhc::custom_check { $name: * => $params }
  }
}
