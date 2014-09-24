require 'spec_helper_acceptance'

describe 'warewulf class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'warewulf': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it_behaves_like 'warewulf::repo'
    it_behaves_like 'warewulf::nhc default'
  end

  context 'when nhc_settings and nhc_checks defined' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'warewulf':
        nhc_settings => {
          'MARK_OFFLINE' => false,
        },
        nhc_checks  => [
          'check_fs_mount_rw -f /',
          'check_fs_mount_rw -t tmpfs -f /tmp',
        ]
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it_behaves_like 'warewulf::repo'
    it_behaves_like 'warewulf::nhc base'

    describe file('/etc/nhc/nhc.conf') do
      it do
        content = subject.content.split(/\n/).reject { |c| c =~ /(^#|^$)/ }
        expected = [
          '* || export MARK_OFFLINE=0',
          '* || check_fs_mount_rw -f /',
          '* || check_fs_mount_rw -t tmpfs -f /tmp',
        ]
        expect(content).to match_array(expected)
      end
    end
  end
end
