# == Define: warewulf::nhc::check
#
define warewulf::nhc::check ($value = $name, $target = '*', $order = '50') {

  datacat_fragment { "warewulf::nhc::check ${title}":
    target  => '/etc/nhc/nhc.conf',
    order   => $order,
    data    => {
      "${target}" => [ $value ],
    }
  }

}
