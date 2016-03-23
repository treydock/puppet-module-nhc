# private class
class nhc::params {

  $checks           = hiera_array('nhc_checks', [])
  $settings         = {}
  $config_overrides = {}

  case $::osfamily {
    'RedHat': {
      $package_url    = "https://github.com/mej/nhc/releases/download/%VERSION%/lbnl-nhc-%VERSION%-%RELEASE%.el${::operatingsystemmajrelease}.noarch.rpm"
      $package_name   = "lbnl-nhc-%VERSION%-%RELEASE%.el${::operatingsystemmajrelease}.noarch"
      $program_name   = 'nhc'
      $conf_dir       = '/etc/nhc'
      $conf_file      = '/etc/nhc/nhc.conf'
      $include_dir    = '/etc/nhc/scripts'
      $log_file       = '/var/log/nhc.log'
      $sysconfig_path = '/etc/sysconfig/nhc'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
