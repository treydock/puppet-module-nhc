# frozen_string_literal: true

require 'spec_helper'

describe 'nhc::custom_check' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(concat_basedir: '/dne')
      end

      let :title do
        'foobar'
      end

      let :params do
        {
          source: 'puppet:///site/foobar.nhc'
        }
      end

      it 'manages custom check' do
        is_expected.to contain_file('/etc/nhc/scripts/foobar.nhc').with(ensure: 'file',
                                                                        owner: 'root',
                                                                        group: 'root',
                                                                        mode: '0644',
                                                                        source: 'puppet:///site/foobar.nhc')
      end
    end
  end
end
