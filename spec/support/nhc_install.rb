shared_examples_for "warewulf::nhc::install" do
  it do
    should contain_package('warewulf-nhc').only_with({
      :ensure => 'present',
      :name   => 'warewulf-nhc',
    })
  end

  context 'when nhc_package_ensure => "absent"' do
    let(:params) {{ :nhc_package_ensure => "absent" }}
    it { should contain_package('warewulf-nhc').with_ensure('absent') }
  end
end
