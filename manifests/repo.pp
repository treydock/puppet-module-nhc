# private class
class warewulf::repo {

  if $warewulf::manage_repo {
    case $::osfamily {
      'RedHat': {
        yumrepo { 'warewulf':
          descr       => $warewulf::repo_descr,
          baseurl     => $warewulf::repo_baseurl,
          gpgcheck    => '0',
          enabled     => $warewulf::repo_enabled,
          includepkgs => $warewulf::repo_includepkgs,
        }
      }

      default: {
        # Do nothing
      }
    }
  }

}
