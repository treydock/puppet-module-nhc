require 'spec_helper'

describe 'warewulf' do
  let(:facts) do
    {
      :osfamily                   => 'RedHat',
      :operatingsystemrelease     => '6.5',
      :operatingsystemmajrelease  => '6',
    }
  end

  it { should create_class('warewulf') }
  it { should contain_class('warewulf::params') }

  it { should contain_anchor('warewulf::start').that_comes_before('Class[warewulf::nhc]') }
  it { should contain_class('warewulf::nhc').that_comes_before('Anchor[warewulf::end]') }
  it { should contain_anchor('warewulf::end') }

  it_behaves_like 'warewulf::nhc'

  context 'when nhc => false' do
    let(:params) {{ :nhc => false }}
    it { should_not contain_class('warewulf::nhc') }
  end

  context 'when ensure => "foo"' do
    let(:params) {{ :ensure => 'foo' }}
    it "should raise an error" do
      expect { should compile }.to raise_error(/Module warewulf: ensure parameter must be 'present' or 'absent', foo given./)
    end
  end

  # Test validate_bool parameters
  [
    :nhc,
    :manage_repo,
    :nhc_detached_mode,
    :nhc_detached_mode_fail_nodata,
    :manage_nhc_logrotate,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param.to_sym => 'foo' }}
      it "should raise an error" do
        expect { should compile }.to raise_error(/is not a boolean/)
      end
    end
  end

  # Test validate_array parameters
  [
    :nhc_checks,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param.to_sym => 'foo' }}
      it "should raise an error" do
        expect { should compile }.to raise_error(/is not an Array/)
      end
    end
  end

  # Test validate_hash parameters
  [
    :nhc_settings,
    :nhc_config_overrides,
  ].each do |param|
    context "with #{param} => 'foo'" do
      let(:params) {{ param.to_sym => 'foo' }}
      it "should raise an error" do
        expect { should compile }.to raise_error(/is not a Hash/)
      end
    end
  end

end
