# private class
class warewulf::repo {

  if $warewulf::manage_repo {
    case $::osfamily {
      'RedHat': {
        # Yumrepo ensure only in Puppet >= 3.5.0
        if versioncmp($::puppetversion, '3.5.0') >= 0 {
          Yumrepo <| title == 'warewulf' |> { ensure => $warewulf::repo_ensure }
        }

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
