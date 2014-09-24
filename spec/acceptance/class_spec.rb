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

  context 'when nhc_checks defined' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'warewulf':
        nhc_checks  => [
          'check_fs_mount_rw /',
          'check_fs_mount_rw /tmp',
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
          '* || check_fs_mount_rw /',
          '* || check_fs_mount_rw /tmp',
        ]
        expect(content).to match_array(expected)
      end
    end
  end
end
