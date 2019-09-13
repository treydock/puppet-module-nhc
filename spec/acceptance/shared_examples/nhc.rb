shared_examples 'nhc-base' do
  describe package('lbnl-nhc') do
    it { is_expected.to be_installed }
  end

  describe file('/etc/nhc') do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 700 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe file('/etc/nhc/scripts') do
    it { is_expected.to be_directory }
    it { is_expected.to be_mode 700 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe file('/etc/nhc/nhc.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end

  describe file('/etc/sysconfig/nhc') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 644 }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'root' }
  end
end
