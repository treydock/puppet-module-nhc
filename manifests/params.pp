# private class
class warewulf::params {

  $nhc_checks           = hiera_array('warewulf_nhc_checks', [])
  $nhc_settings         = {}
  $nhc_config_overrides = {}

  case $::osfamily {
    'RedHat': {
      $repo_descr         = "Warewulf Releases -- RHEL ${::operatingsystemmajrelease}"
      $repo_baseurl       = "http://warewulf.lbl.gov/downloads/repo/rhel${::operatingsystemmajrelease}/"
      $nhc_name           = 'nhc'
      $nhc_conf_dir       = '/etc/nhc'
      $nhc_conf_file      = '/etc/nhc/nhc.conf'
      $nhc_include_dir    = '/etc/nhc/scripts'
      $nhc_log_file       = '/var/log/nhc.log'
      $nhc_sysconfig_path = '/etc/sysconfig/nhc'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
