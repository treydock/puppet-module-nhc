shared_context 'warewulf::nhc' do
  describe package('warewulf-nhc') do
    it { should be_installed }
  end

  describe file('/etc/nhc') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/etc/nhc/scripts') do
    it { should be_directory }
    it { should be_mode 755 }
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

shared_examples_for "warewulf::nhc base" do
  include_context "warewulf::nhc"
end

shared_examples_for "warewulf::nhc default" do
  include_context "warewulf::nhc"

  describe file('/etc/nhc/nhc.conf') do
    it do
      content = subject.content.split(/\n/).reject { |c| c =~ /(^#|^$)/ }
      expected = []
      expect(content).to match_array(expected)
    end
  end

  describe file('/etc/sysconfig/nhc') do
    it do
      content = subject.content.split(/\n/).reject { |c| c =~ /(^#|^$)/ }
      expected = [
        'CONFDIR=/etc/nhc',
        'CONFFILE=/etc/nhc/nhc.conf',
        'DETACHED_MODE=0',
        'DETACHED_MODE_FAIL_NODATA=0',
        'INCDIR=/etc/nhc/scripts',
         'NAME=nhc',
      ]
      expect(content).to match_array(expected)
    end
  end
end
