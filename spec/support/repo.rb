shared_examples_for 'warewulf::repo' do
  let(:facts) do
    {
      :osfamily                   => 'RedHat',
      :operatingsystemrelease     => '6.5',
      :operatingsystemmajrelease  => '6',
      :puppetversion              => PUPPET_VERSION,
    }
  end

  it { should create_class('warewulf::repo') }

  context 'osfamily => RedHat' do
    let(:facts) do
      {
        :osfamily                   => 'RedHat',
        :operatingsystemrelease     => '6.5',
        :operatingsystemmajrelease  => '6',
        :puppetversion              => PUPPET_VERSION,
      }
    end

    it do
      should contain_yumrepo('warewulf').with({
        :name         => 'warewulf',
        :descr        => 'Warewulf Releases -- RHEL 6',
        :baseurl      => 'http://warewulf.lbl.gov/downloads/repo/rhel6/',
        :gpgcheck     => '0',
        :enabled      => '1',
        :includepkgs  => 'absent',
      })
    end

    context "with custom baseurl" do
      let(:params) {{ :repo_baseurl => 'http://yum.example.com/warewulf/rhel6' }}

      it { should contain_yumrepo('warewulf').with_baseurl('http://yum.example.com/warewulf/rhel6') }
    end

    context "with enabled => '0'" do
      let(:params) {{ :repo_enabled => '0' }}

      it { should contain_yumrepo('warewulf').with_enabled('0') }
    end

    context "with repo_includepkgs => 'warewulf-nhc'" do
      let(:params) {{ :repo_includepkgs => 'warewulf-nhc' }}

      it { should contain_yumrepo('warewulf').with_includepkgs('warewulf-nhc') }
    end

    if Gem::Version.new(PUPPET_VERSION) >= Gem::Version.new('3.5.0')
      it { should contain_yumrepo('warewulf').with_ensure('present') }

      context 'when repo_ensure => "absent"' do
        let(:params) {{ :repo_ensure => "absent" }}
        it { should contain_yumrepo('warewulf').with_ensure('absent') }
      end
    end
  end
end
