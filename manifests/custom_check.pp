# == Define: nhc::custom_check
#
define nhc::custom_check (
  $source = undef,
) {

  include ::nhc

  file { "${nhc::include_dir}/${name}.nhc":
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => $source,
  }

}
