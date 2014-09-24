shared_examples_for 'warewulf::repo' do
  describe yumrepo('warewulf') do
    it { should exist }
    it { should be_enabled }
  end
end
