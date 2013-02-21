# spec/classes/tomcat6_spec.rb

require 'spec_helper'

describe 'tomcat6' do


  context 'when Debian' do

    let(:params) do
      {:tomcat_user => 'tomcat6',
       :lang        => 'fr_FR',
       :java_opts   => '-Xms128m'}
    end

    let(:facts) do
      {:osfamily => 'Debian',
       :operatingsystem => 'Debian'}
    end

    it 'does not install jpackage' do
      should_not include_class('jpackage')
    end

    it 'install tomcat6' do
      should contain_package('tomcat6').with({'ensure' => 'installed'})
    end

    it 'configure tomcat6 accordingly (/etc/default/tomcat6)' do
      should contain_file('/etc/default/tomcat6')\
        .with_content(/^TOMCAT6_USER=tomcat6$/)\
        .with_content(/^JAVA_OPTS="-Xms128m"$/)\
        .with_content(/^LANG="fr_FR"$/)
    end

    it 'configure the tomcat6 service accordingly' do
      should contain_service('tomcat6').with({
        'ensure' => 'running',
        'hasrestart' => 'true',
        'hasstatus' => 'true',
        'enable' => 'true',
      })
    end

  end

  context 'when CenOS' do

    let(:params) do
      {:tomcat_user => 'tomcat6',
       :lang        => 'fr_FR',
       :java_opts   => '-Xms128m'}
    end

    let(:facts) do
      {:osfamily => 'RedHat',
       :operatingsystem => 'CentOS'}
    end

    it 'install jpackage' do
      should include_class('jpackage')
    end

    it 'install tomcat6' do
      should contain_package('tomcat6').with({'ensure' => 'installed'})
    end

    it 'configure tomcat6 accordingly (/etc/sysconfig/tomcat6)' do
      should contain_file('/etc/sysconfig/tomcat6')\
        .with_content(/^TOMCAT6_USER=tomcat6$/)\
        .with_content(/^JAVA_OPTS="-Xms128m"$/)\
        .with_content(/^LANG="fr_FR"$/)
    end

    it 'configure the tomcat6 service accordingly' do
      should contain_service('tomcat6').with({
        'ensure' => 'running',
        'hasrestart' => 'true',
        'hasstatus' => 'true',
        'enable' => 'true',
      })
    end

  end

end
