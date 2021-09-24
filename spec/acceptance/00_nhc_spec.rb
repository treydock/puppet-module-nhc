require 'spec_helper_acceptance'

describe 'nhc class:', if: fact('os.family') == 'RedHat' && fact('os.release.major') == '7' do
  context 'default parameters' do
    it 'runs successfully' do
      pp = <<-EOS
      class { 'nhc': }
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it_behaves_like 'nhc-package'
    it_behaves_like 'nhc-base'
  end
end
