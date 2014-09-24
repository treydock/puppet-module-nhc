shared_examples_for 'warewulf::nhc' do
  it { should create_class('warewulf::nhc') }

  it { should contain_anchor('warewulf::nhc::start').that_comes_before('Class[warewulf::repo]') }
  it { should contain_class('warewulf::repo').that_comes_before('Class[warewulf::nhc::install]') }
  it { should contain_class('warewulf::nhc::install').that_comes_before('Class[warewulf::nhc::config]') }
  it { should contain_class('warewulf::nhc::config').that_comes_before('Anchor[warewulf::nhc::end]') }
  it { should contain_anchor('warewulf::nhc::end') }

  it_behaves_like 'warewulf::repo'
  it_behaves_like 'warewulf::nhc::install'
  it_behaves_like 'warewulf::nhc::config'

end
