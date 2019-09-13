# @summary Add NHC custom check file
#
# @example Define custom NHC check file
#   nhc::custom_check { 'osc_gpfs':
#     source => 'puppet:///modules/profile/nhc/osc_gpfs.nhc',
#   }
#
# @param source
#   The source of the custom check
#
define nhc::custom_check (
  Optional[String] $source = undef,
) {

  include ::nhc

  file { "${::nhc::include_dir}/${name}.nhc":
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => $source,
  }

}
