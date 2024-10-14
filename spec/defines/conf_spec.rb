# frozen_string_literal: true

require 'spec_helper'

describe 'nhc::conf' do
  on_supported_os.each do |os, facts|
    context "when #{os}" do
      let(:facts) do
        facts.merge(concat_basedir: '/dne')
      end

      let :title do
        'nhc-cron'
      end

      let :params do
        {
          settings: {
            'HOSTNAME' => '$HOSTNAME_S',
          },
          settings_host: {
            'foo' => { 'MARK_OFFLINE' => false },
          },
          checks: [
            'check_fs_mount_rw -f /',
            'check_fs_mount_rw -t tmpfs -f /tmp',
          ],
        }
      end

      it { is_expected.to compile.with_all_deps }

      it 'manages conf file' do
        is_expected.to contain_file('/etc/nhc/nhc-cron.conf').with(ensure: 'file',
                                                                   owner: 'root',
                                                                   group: 'root',
                                                                   mode: '0644',)
      end

      it do
        verify_exact_contents(catalogue, '/etc/nhc/nhc-cron.conf', [
                                '* || export HOSTNAME=$HOSTNAME_S',
                                'foo || export MARK_OFFLINE=0',
                                '* || check_fs_mount_rw -f /',
                                '* || check_fs_mount_rw -t tmpfs -f /tmp',
                              ],)
      end

      it 'manages sysconfig file' do
        is_expected.to contain_file('/etc/sysconfig/nhc-cron').with(ensure: 'file',
                                                                    owner: 'root',
                                                                    group: 'root',
                                                                    mode: '0644',)
      end
    end
  end
end
