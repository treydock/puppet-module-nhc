require 'spec_helper'

describe "warewulf::nhc::check" do
  let(:facts) do
    {
      :osfamily                   => 'RedHat',
      :operatingsystemrelease     => '6.5',
      :operatingsystemmajrelease  => '6',
    }
  end

  let(:title) { 'check_fs_mount_rw /tmp' }
  let(:params) {{}}

  it do
    should contain_datacat_fragment('warewulf::nhc::check check_fs_mount_rw /tmp').with({
      :target => '/etc/nhc/nhc.conf',
      :order  => '50',
      :data   => {'*' => ['check_fs_mount_rw /tmp']}
    })
  end

  context 'when value defined' do
    let(:title) { 'tmp rw' }
    let(:params) {{ :value => 'check_fs_mount_rw /tmp' }}

    it do
      should contain_datacat_fragment('warewulf::nhc::check tmp rw').with({
        :target => '/etc/nhc/nhc.conf',
        :order  => '50',
        :data   => {'*' => ['check_fs_mount_rw /tmp']}
      })
    end
  end

end
