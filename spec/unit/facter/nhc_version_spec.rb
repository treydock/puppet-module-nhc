require 'spec_helper'

describe 'nhc_version fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:osfamily)).to receive(:value).and_return('RedHat')
  end

  it 'returns 1.4.1' do
    allow(Facter::Util::Resolution).to receive(:exec).with("rpm -q --queryformat '%{NAME}-%{VERSION}' lbnl-nhc").and_return('lbnl-nhc-1.4.2')
    expect(Facter.fact(:nhc_version).value).to eq('1.4.2')
  end

  it 'handles package not installed' do
    allow(Facter::Util::Resolution).to receive(:exec).with("rpm -q --queryformat '%{NAME}-%{VERSION}' lbnl-nhc").and_return("package lbnl-nhc is not installed\n")
    expect(Facter.fact(:nhc_version).value).to be_nil
  end
end
