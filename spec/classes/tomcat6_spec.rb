# spec/classes/tomcat6_spec.rb

require 'spec_helper'

describe 'tomcat6' do

  context 'when Debian' do

    let(:facts) do
      {:osfamily => 'Debian',
       :operatingsystem => 'Debian'}
    end

    it 'install tomcat6' do
      should contain_package('tomcat6').with({'ensure' => 'installed'})
    end

    it 'configure tomcat6 accordingly (/etc/default/tomcat6)' do
      should contain_file('/etc/default/tomcat6')
    end

  end

  context 'when CenOS' do

    let(:facts) do
      {:osfamily => 'RedHat',
       :operatingsystem => 'CentOS'}
    end

    it 'install tomcat6' do
      should contain_package('tomcat6').with({'ensure' => 'installed'})
    end

    it 'configure tomcat6 accordingly (/etc/sysconfig/tomcat6)' do
      should contain_file('/etc/sysconfig/tomcat6')
    end

  end

end
