require 'spec_helper_acceptance'

describe 'nhc class:' do
  context 'ensure => absent' do
    it 'runs successfully' do
      pp = <<-EOS
      class { 'nhc': ensure => 'absent' }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('lbnl-nhc') do
      it { is_expected.not_to be_installed }
    end
  end

  context 'when installed from source' do
    it 'runs successfully' do
      pp = <<-EOS
      class { 'nhc':
        install_method => 'source',
      }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
