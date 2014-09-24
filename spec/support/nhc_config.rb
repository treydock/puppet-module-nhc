shared_examples_for "warewulf::nhc::config" do
  it do
    should contain_file('/etc/nhc').with({
      :ensure  => 'directory',
      :path    => '/etc/nhc',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0755',
    })
  end

  it do
    should contain_datacat('/etc/nhc/nhc.conf').with({
      :ensure   => 'file',
      :path     => '/etc/nhc/nhc.conf',
      :template => 'warewulf/nhc/nhc.conf.erb',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
      :require  => 'File[/etc/nhc]',
    })
  end

  it { should contain_datacat_collector('/etc/nhc/nhc.conf') }
  it { should have_warewulf__nhc__setting_resource_count(0) }
  it { should have_datacat_fragment_resource_count(0) }

  it do
    should contain_file('/etc/nhc/scripts').with({
      :ensure   => 'directory',
      :path     => '/etc/nhc/scripts',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0755',
      :require  => 'File[/etc/nhc]',
    })
  end

  it do
    should contain_file('/etc/sysconfig/nhc').with({
      :ensure   => 'file',
      :path     => '/etc/sysconfig/nhc',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_contents(catalogue, '/etc/sysconfig/nhc', [
      'CONFDIR=/etc/nhc',
      'CONFFILE=/etc/nhc/nhc.conf',
      'DETACHED_MODE=0',
      'DETACHED_MODE_FAIL_NODATA=0',
      'INCDIR=/etc/nhc/scripts',
      'NAME=nhc',
    ])
  end

  it 'should manage logrotate::rule[nhc]' do
    should contain_logrotate__rule('nhc').with({
      :ensure       => 'present',
      :path         => '/var/log/nhc.log',
      :missingok    => 'true',
      :ifempty      => 'false',
      :rotate_every => 'weekly',
    })
  end

  it 'File[/etc/logrotate.d/nhc] should have valid contents' do
    verify_contents(catalogue, '/etc/logrotate.d/nhc', [
      '/var/log/nhc.log {',
      '  missingok',
      '  notifempty',
      '  weekly',
      '}',
    ])
  end

  context 'when detached_mode => true' do
    let(:params) {{ :detached_mode => true }}
    it { verify_contents(catalogue, '/etc/sysconfig/nhc', ['DETACHED_MODE=1']) }
  end

  context 'when detached_mode_fail_nodata => true' do
    let(:params) {{ :detached_mode_fail_nodata => true }}
    it { verify_contents(catalogue, '/etc/sysconfig/nhc', ['DETACHED_MODE_FAIL_NODATA=1']) }
  end

  context 'when nhc_config_overrides is defined' do
    let(:params) do
      {
        :nhc_config_overrides => {
          'HOSTNAME'  => '$HOSTNAME_S',
        }
      }
    end

    it { verify_contents(catalogue, '/etc/sysconfig/nhc', ['HOSTNAME=$HOSTNAME_S']) }
  end

  context 'when nhc_checks defined as an Array' do
    let(:params) do
      {
        :nhc_checks => [
          'check_fs_mount_rw /tmp',
          'check_fs_mount_rw /',
        ]
      }
    end

    it { should have_warewulf__nhc__check_resource_count(2) }
    it { should have_datacat_fragment_resource_count(2) }

    it do
      should contain_warewulf__nhc__check('check_fs_mount_rw /tmp').with({
        :value  => 'check_fs_mount_rw /tmp',
        :target => '*',
        :order  => '50',
      })
    end

    it do
      should contain_warewulf__nhc__check('check_fs_mount_rw /').with({
        :value  => 'check_fs_mount_rw /',
        :target => '*',
        :order  => '50',
      })
    end

    it { should contain_datacat_fragment('warewulf::nhc::check check_fs_mount_rw /tmp') }
    it { should contain_datacat_fragment('warewulf::nhc::check check_fs_mount_rw /') }
  end

  context 'when nhc_checks defined as a Hash' do
    let(:params) do
      {
        :nhc_checks => {
          'tmp rw' => {
            'value'   => 'check_fs_mount_rw /tmp',
            'target'  => '*',
          },
          'root rw' => {
            'value'   => 'check_fs_mount_rw /',
            'target'  => '*',
          }
        }
      }
    end

    it { should have_warewulf__nhc__check_resource_count(2) }
    it { should have_datacat_fragment_resource_count(2) }

    it do
      should contain_warewulf__nhc__check('tmp rw').with({
        :value  => 'check_fs_mount_rw /tmp',
        :target => '*',
        :order  => '50',
      })
    end

    it do
      should contain_warewulf__nhc__check('root rw').with({
        :value  => 'check_fs_mount_rw /',
        :target => '*',
        :order  => '50',
      })
    end

    it { should contain_datacat_fragment('warewulf::nhc::check tmp rw') }
    it { should contain_datacat_fragment('warewulf::nhc::check root rw') }
  end

  context 'when manage_nhc_logrotate => false' do
    let(:params) {{ :manage_nhc_logrotate => false }}
    it { should_not contain_logrotate__rule('nhc') }
  end

  context 'when ensure => "absent"' do
    let(:params) {{ :ensure => "absent" }}
    it { should contain_file('/etc/nhc').with_ensure('absent') }
    it { should contain_file('/etc/nhc/nhc.conf').with_ensure('absent') }
    it { should contain_file('/etc/nhc').with_ensure('absent') }
    it { should contain_file('/etc/sysconfig/nhc').with_ensure('absent') }
    it { should contain_logrotate__rule('nhc').with_ensure('absent') }
  end
end
