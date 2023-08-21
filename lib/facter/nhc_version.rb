# frozen_string_literal: true

# nhc_version.rb

Facter.add(:nhc_version) do
  confine osfamily: 'RedHat'

  setcode do
    nhc_v = nil
    nhc_v_match = nil
    nhc_v_out = Facter::Core::Execution.execute("rpm -q --queryformat '%{NAME}-%{VERSION}' lbnl-nhc")
    nhc_v_match = nhc_v_out.match(%r{^lbnl-nhc-(.*)$}) unless nhc_v_out.nil?
    if nhc_v_match
      nhc_v = nhc_v_match[1]
    end
    nhc_v
  end
end
