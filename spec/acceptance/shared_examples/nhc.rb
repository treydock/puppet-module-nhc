shared_context 'nhc-base' do
  describe package('lbnl-nhc') do
    it { should be_installed }
  end

  describe file('/etc/nhc') do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/nhc/scripts') do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/nhc/nhc.conf') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/sysconfig/nhc') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
