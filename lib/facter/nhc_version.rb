# nhc_version.rb

Facter.add(:nhc_version) do
  confine :osfamily => "RedHat"

  if nhc_v_match = Facter::Util::Resolution.exec("rpm -q --queryformat '%{NAME}-%{VERSION}' warewulf-nhc").match(/^warewulf-nhc-(.*)$/)
    setcode do
      nhc_v = nhc_v_match[1]
      nhc_v
    end
  end
end
