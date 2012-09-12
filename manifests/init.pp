class tomcat6 ($config_hash = {},) inherits tomcat6::params {

  if $::osfamily == "RedHat" {
	include yum_priorities, epel, repoforge, jpackage

    #
    # The following two statement are there to correct an incorrect behvoir of CentOS 5 Series related to JPackage.
    # TODO Check if this applies also for CentOS 6 Series
    # Missing Dependency: /usr/bin/rebuild-security-providers is needed by package java-1.4.2-gcj-compat-1.4.2.0-40jpp.115.i386 (base)
    #
    exec {'rpm -Uvh http://plone.lucidsolutions.co.nz/linux/centos/images/jpackage-utils-compat-el5-0.0.1-1.noarch.rpm' :
      path    => '/bin',
      before  => Notify['start_installation'],
      unless  => 'rpm -q jpackage-utils-compat-el5-0.0.1-1.noarch';
    }
  }

  notify {'start_installation' : }

  package {'tomcat6' :
    ensure  => installed,
	name    => 'tomcat6',
    require => Notify['start_installation'],
  }

  service {'tomcat6' :
    ensure  => running,
    enable  => true,
	require => Package['tomcat6'],
  }

  class {'tomcat6::config' :
	  config_hash => $config_hash,
	  require     => Service['tomcat6'],
  }

}
