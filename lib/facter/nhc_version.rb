# nhc_version.rb

Facter.add(:nhc_version) do
  confine osfamily: 'RedHat'

  setcode do
    nhc_v = nil
    nhc_v_match = Facter::Util::Resolution.exec("rpm -q --queryformat '%{NAME}-%{VERSION}' lbnl-nhc").match(%r{^lbnl-nhc-(.*)$})
    if nhc_v_match
      nhc_v = nhc_v_match[1]
    end
    nhc_v
  end
end
