# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nhc class:', if: fact('os.family') == 'RedHat' && fact('os.release.major') != '9' do
  context 'with default parameters' do
    it 'runs successfully' do
      pp = <<-PP
      class { 'nhc': }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it_behaves_like 'nhc-package'
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
