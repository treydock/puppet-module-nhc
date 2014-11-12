shared_examples_for "warewulf::nhc::config" do
  it do
    should contain_file('/etc/nhc').with({
      :ensure  => 'directory',
      :path    => '/etc/nhc',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0700',
    })
  end

  it do
    should contain_file('/etc/nhc/nhc.conf').with({
      :ensure   => 'file',
      :path     => '/etc/nhc/nhc.conf',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
      :require  => 'File[/etc/nhc]',
    })
  end

  it do
    verify_exact_contents(catalogue, '/etc/nhc/nhc.conf', [])
  end

  it do
    should contain_file('/etc/nhc/scripts').with({
      :ensure   => 'directory',
      :path     => '/etc/nhc/scripts',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0700',
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
    verify_exact_contents(catalogue, '/etc/sysconfig/nhc', [
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

  context 'when nhc_detached_mode => true' do
    let(:params) {{ :nhc_detached_mode => true }}
    it { verify_contents(catalogue, '/etc/sysconfig/nhc', ['DETACHED_MODE=1']) }
  end

  context 'when nhc_detached_mode_fail_nodata => true' do
    let(:params) {{ :nhc_detached_mode_fail_nodata => true }}
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

  context 'when nhc_settings is defined' do
    let(:params) do
      {
        :nhc_settings => {
          'HOSTNAME'  => '$HOSTNAME_S',
        }
      }
    end

    it { verify_contents(catalogue, '/etc/nhc/nhc.conf', ['* || export HOSTNAME=$HOSTNAME_S']) }
  end

  context 'when nhc_checks defined as an Array' do
    let(:params) do
      {
        :nhc_checks => [
          'check_fs_mount_rw -f /',
          'check_fs_mount_rw -t tmpfs -f /tmp',
        ]
      }
    end

    it do
      verify_exact_contents(catalogue, '/etc/nhc/nhc.conf', [
        '* || check_fs_mount_rw -f /',
        '* || check_fs_mount_rw -t tmpfs -f /tmp',
      ])
    end
  end

  context 'when nhc_checks defined as a Hash' do
    let(:params) do
      {
        :nhc_checks => {
          '*' => [
            'check_fs_mount_rw -f /',
            'check_fs_mount_rw -t tmpfs -f /tmp',
          ],
          'foo.bar' => [
            'check_hw_physmem_free 1MB',
          ],
          'foo.baz' => 'check_hw_swap_free 1MB',
        }
      }
    end

    it do
      content = catalogue.resource('file', '/etc/nhc/nhc.conf').send(:parameters)[:content]
      pp content.split(/\n/)
      verify_exact_contents(catalogue, '/etc/nhc/nhc.conf', [
        '* || check_fs_mount_rw -f /',
        '* || check_fs_mount_rw -t tmpfs -f /tmp',
        'foo.bar || check_hw_physmem_free 1MB',
        'foo.baz || check_hw_swap_free 1MB',
      ])
    end
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
