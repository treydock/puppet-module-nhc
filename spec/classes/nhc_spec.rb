require 'spec_helper'

describe 'nhc' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:source) { "https://github.com/mej/nhc/releases/download/1.4.2/lbnl-nhc-1.4.2-1.el#{facts[:operatingsystemmajrelease]}.noarch.rpm" }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to create_class('nhc') }

      it { is_expected.to contain_class('nhc::install').that_comes_before('Class[nhc::config]') }
      it { is_expected.to contain_class('nhc::config') }

      context 'nhc::install' do
        it do
          if facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'] == '8'
            is_expected.to have_yum__install_count(0)
          else
            is_expected.to contain_yum__install("lbnl-nhc-1.4.2-1.el#{facts[:operatingsystemmajrelease]}.noarch").only_with(ensure: 'present', source: source)
          end
        end

        context 'when install_method => repo' do
          let(:params) { { install_method: 'repo', repo_name: 'local' } }
          let(:pre_condition) do
            "yumrepo { 'local':
              descr     => 'local',
              baseurl   => 'file:///dne',
              gpgcheck  => '0',
              enabled   => '1',
            }"
          end

          it do
            is_expected.to contain_package('lbnl-nhc').only_with(ensure: "1.4.2-1.el#{facts[:operatingsystemmajrelease]}",
                                                                 name: 'lbnl-nhc',
                                                                 require: 'Yumrepo[local]')
          end

          context 'when package_ensure => "latest"' do
            let(:params) { { install_method: 'repo', repo_name: 'local', package_ensure: 'latest' } }

            it { is_expected.to contain_package('lbnl-nhc').with_ensure('latest') }
          end
        end

        context 'when install_method => source' do
          let(:params) { { install_method: 'source' } }

          it { is_expected.to compile.with_all_deps }
        end

        context 'when ensure => "absent"' do
          let(:params) { { ensure: 'absent' } }

          it { is_expected.to contain_yum__install("lbnl-nhc-1.4.2-1.el#{facts[:operatingsystemmajrelease]}.noarch").with_ensure('absent') }
        end
      end

      context 'nhc::config' do
        it do
          is_expected.to contain_file('/etc/nhc').with(ensure: 'directory',
                                                       path: '/etc/nhc',
                                                       owner: 'root',
                                                       group: 'root',
                                                       mode: '0700')
        end

        it do
          is_expected.to contain_file('/etc/nhc/nhc.conf').with(ensure: 'file',
                                                                path: '/etc/nhc/nhc.conf',
                                                                owner: 'root',
                                                                group: 'root',
                                                                mode: '0644',
                                                                require: 'File[/etc/nhc]')
        end

        it do
          verify_exact_contents(catalogue, '/etc/nhc/nhc.conf', [])
        end

        it do
          is_expected.to contain_file('/etc/nhc/scripts').with(ensure: 'directory',
                                                               path: '/etc/nhc/scripts',
                                                               owner: 'root',
                                                               group: 'root',
                                                               mode: '0700',
                                                               require: 'File[/etc/nhc]')
        end

        it do
          is_expected.to contain_file('/etc/sysconfig/nhc').with(ensure: 'file',
                                                                 path: '/etc/sysconfig/nhc',
                                                                 owner: 'root',
                                                                 group: 'root',
                                                                 mode: '0644')
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

        it 'manages logrotate::rule[nhc]' do
          is_expected.to contain_logrotate__rule('nhc').with(ensure: 'present',
                                                             path: '/var/log/nhc.log',
                                                             missingok: 'true',
                                                             ifempty: 'false',
                                                             rotate_every: 'weekly')
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
          let(:params) { { detached_mode: true } }

          it { verify_contents(catalogue, '/etc/sysconfig/nhc', ['DETACHED_MODE=1']) }
        end

        context 'when detached_mode_fail_nodata => true' do
          let(:params) { { detached_mode_fail_nodata: true } }

          it { verify_contents(catalogue, '/etc/sysconfig/nhc', ['DETACHED_MODE_FAIL_NODATA=1']) }
        end

        context 'when config_overrides is defined' do
          let(:params) do
            {
              config_overrides: {
                'HOSTNAME'  => '$HOSTNAME_S',
              },
            }
          end

          it { verify_contents(catalogue, '/etc/sysconfig/nhc', ['HOSTNAME=$HOSTNAME_S']) }
        end

        context 'when settings are defined' do
          let(:params) do
            {
              settings: {
                'HOSTNAME'  => '$HOSTNAME_S',
              },
            }
          end

          it do
            content = catalogue.resource('file', '/etc/nhc/nhc.conf').send(:parameters)[:content]
            puts content.split(%r{\n})
            verify_exact_contents(catalogue, '/etc/nhc/nhc.conf', [
                                    '* || export HOSTNAME=$HOSTNAME_S',
                                  ])
          end
        end

        context 'when host settings are defined' do
          let(:params) do
            {
              settings: {
                'HOSTNAME'  => '$HOSTNAME_S',
              },
              settings_host: {
                'foo' => { 'MARK_OFFLINE' => false },
              },
            }
          end

          it do
            content = catalogue.resource('file', '/etc/nhc/nhc.conf').send(:parameters)[:content]
            puts content.split(%r{\n})
            verify_exact_contents(catalogue, '/etc/nhc/nhc.conf', [
                                    '* || export HOSTNAME=$HOSTNAME_S',
                                    'foo || export MARK_OFFLINE=0',
                                  ])
          end
        end

        context 'when checks defined as an Array' do
          let(:params) do
            {
              checks: [
                'check_fs_mount_rw -f /',
                'check_fs_mount_rw -t tmpfs -f /tmp',
              ],
            }
          end

          it do
            verify_exact_contents(catalogue, '/etc/nhc/nhc.conf', [
                                    '* || check_fs_mount_rw -f /',
                                    '* || check_fs_mount_rw -t tmpfs -f /tmp',
                                  ])
          end
        end

        context 'when checks defined as a Hash' do
          let(:params) do
            {
              checks: {
                '*' => [
                  'check_fs_mount_rw -f /',
                  'check_fs_mount_rw -t tmpfs -f /tmp',
                ],
                'foo.bar' => [
                  'check_hw_physmem_free 1MB',
                ],
                'foo.baz' => 'check_hw_swap_free 1MB',
              },
            }
          end

          it do
            content = catalogue.resource('file', '/etc/nhc/nhc.conf').send(:parameters)[:content]
            puts content.split(%r{\n})
            verify_exact_contents(catalogue, '/etc/nhc/nhc.conf', [
                                    '* || check_fs_mount_rw -f /',
                                    '* || check_fs_mount_rw -t tmpfs -f /tmp',
                                    'foo.bar || check_hw_physmem_free 1MB',
                                    'foo.baz || check_hw_swap_free 1MB',
                                  ])
          end
        end

        context 'when ensure => "absent"' do
          let(:params) { { ensure: 'absent' } }

          it { is_expected.to contain_file('/etc/nhc').with_ensure('absent') }
          it { is_expected.to contain_file('/etc/nhc/nhc.conf').with_ensure('absent') }
          it { is_expected.to contain_file('/etc/sysconfig/nhc').with_ensure('absent') }
          it { is_expected.to contain_logrotate__rule('nhc').with_ensure('absent') }
        end
      end
    end # end os context
  end # end on_supported_os
end # end describe nhc
