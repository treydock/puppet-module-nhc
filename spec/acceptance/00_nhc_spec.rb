require 'spec_helper_acceptance'

describe 'nhc class:' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'nhc': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it_behaves_like 'nhc-base'

    describe file('/etc/nhc/nhc.conf') do
      it do
        content = subject.content.split(/\n/).reject { |c| c =~ /(^#|^$)/ }
        expected = []
        expect(content).to match_array(expected)
      end
    end
  end

  context 'when nhc_settings and nhc_checks defined' do
    it 'should run successfully' do
      pp =<<-EOS
      class { 'nhc':
        settings => {
          'MARK_OFFLINE' => false,
        },
        checks  => [
          'check_fs_mount_rw -f /',
          'check_fs_mount_rw -t tmpfs -f /tmp',
        ]
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it_behaves_like 'nhc-base'

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
end
