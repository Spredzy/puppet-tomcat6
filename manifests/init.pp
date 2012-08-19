class tomcat6 ($config_hash = {},) inherits tomcat6::params {

  Class['tomcat6'] -> Class['tomcat6::config']

  class {'tomcat6::config' :
	  config_hash => $config_hash,
  }

  if $osfamily == "RedHat" {

    $yum_priorities = $lsbmajdistrelease ? {
      /4|6/	=> 'yum-plugin-priorities',
      '5'		=> 'yum-priorities',
    }

    package {$yum_priorities :
      ensure    => installed,
    }

    package {'java-1.6.0-openjdk' :
      ensure	=> installed,
    }

    Exec { path =>  ['/bin', '/usr/bin'], require => [Package[$yum_priorities],Package['java-1.6.0-openjdk']]}
    exec {
      "rpm -Uvh $epel_url" :
        before  => Exec["rpm -Uvh $rpmforge_url"],
        unless  => 'rpm -qa | grep epel-release';
      "rpm -Uvh $rpmforge_url" :
        before  => Exec['wget http://jpackage.org/jpackage50.repo'],
        unless  => 'rpm -qa | grep rpmforge-release';
      'wget http://jpackage.org/jpackage50.repo' :
        cwd     => '/etc/yum.repos.d/',
        unless  => 'ls -la /etc/yum.repos.d/ | grep jpackage';
    }

    #
    # The following two statement are there to correct an incorrect behvoir of CentOS 5 Series related to JPackage.
    # TODO Check if this applies also for CentOS 6 Series
    # Missing Dependency: /usr/bin/rebuild-security-providers is needed by package java-1.4.2-gcj-compat-1.4.2.0-40jpp.115.i386 (base)
    #
    exec {'rpm -Uvh http://plone.lucidsolutions.co.nz/linux/centos/images/jpackage-utils-compat-el5-0.0.1-1.noarch.rpm' :
      path    => ['/usr/bin', '/bin'],
      require => Exec['wget http://jpackage.org/jpackage50.repo'],
      before  => Notify['start_installation'],
      unless  => 'rpm -qa | grep jpackage-utils-compat-el5-0.0.1-1';
    }
  }

  notify {'start_installation' : }

  package {'tomcat6' :
    ensure  => installed,
	name    => 'tomcat6',
    require => Notify['start_installation'],
  }

  service {'tomcat6' :
    ensure     => running,
    enable     => true,
	require    => Package['tomcat6'],
  }

}
