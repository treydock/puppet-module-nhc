# private class
class warewulf::nhc {

  include warewulf::repo
  include warewulf::nhc::install
  include warewulf::nhc::config
  
  anchor { 'warewulf::nhc::start': }->
  Class['warewulf::repo']->
  Class['warewulf::nhc::install']->
  Class['warewulf::nhc::config']->
  anchor { 'warewulf::nhc::end': }

}
