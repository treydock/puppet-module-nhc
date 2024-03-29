# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nhc class:', if: fact('os.family') == 'RedHat' && fact('os.release.major') != '9' do
  context 'when installed from repo' do
    it 'runs successfully' do
      pp = <<-PP
      yumrepo { 'nhc':
        descr               => 'nhc',
        baseurl             => 'file:///opt/nhc-repo',
        gpgcheck            => '0',
        enabled             => '1',
        skip_if_unavailable => '1',
      }
      package { 'createrepo': ensure => 'installed' }->
      file { '/opt/nhc-repo': ensure => 'directory' }->
      exec { 'wget nhc':
        path    => '/usr/bin:/bin:/usr/sbin:/sbin',
        command => 'wget -O /opt/nhc-repo/lbnl-nhc-1.4.3-1.el#{fact('operatingsystemmajrelease')}.noarch.rpm https://github.com/mej/nhc/releases/download/1.4.3/lbnl-nhc-1.4.3-1.el#{fact('operatingsystemmajrelease')}.noarch.rpm',
        creates => '/opt/nhc-repo/lbnl-nhc-1.4.3-1.el#{fact('operatingsystemmajrelease')}.noarch.rpm',
      }~>
      exec { 'createrepo-nhc':
        path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        command     => 'createrepo /opt/nhc-repo',
        refreshonly => true,
      }~>
      exec { 'refresh-repo-nhc':
        path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        command     => 'yum clean metadata --disablerepo=* --enablerepo=nhc',
        refreshonly => true,
        require     => Yumrepo['nhc'],
      }

      class { 'nhc':
        install_method => 'repo',
        repo_name => 'nhc',
      }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it_behaves_like 'nhc-base'
  end

  context 'when ensure => absent' do
    it 'runs successfully' do
      pp = <<-PP
      class { 'nhc': ensure => 'absent' }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('lbnl-nhc') do
      it { is_expected.not_to be_installed }
    end
  end
end
