require 'spec_helper'

describe 'nhc::conf' do
  on_supported_os({
    :supported_os => [
      {
        "operatingsystem" => "CentOS",
        "operatingsystemrelease" => ["6", "7"],
      }
    ]
  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/dne',
        })
      end

      let :title do
        'nhc-cron'
      end

      let :params do
        {
          :settings => {
            '*' => { 'HOSTNAME'  => '$HOSTNAME_S' },
          },
          :checks => [
            'check_fs_mount_rw -f /',
            'check_fs_mount_rw -t tmpfs -f /tmp',
          ],
        }
      end

      it { is_expected.to compile.with_all_deps }

      it 'should manage conf file' do
        is_expected.to contain_file('/etc/nhc/nhc-cron.conf').with({
          :ensure => 'file',
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0644',
        })
      end

      it do
        verify_exact_contents(catalogue, '/etc/nhc/nhc-cron.conf', [
          '* || export HOSTNAME=$HOSTNAME_S',
          '* || check_fs_mount_rw -f /',
          '* || check_fs_mount_rw -t tmpfs -f /tmp',
        ])
      end

    end
  end
end
