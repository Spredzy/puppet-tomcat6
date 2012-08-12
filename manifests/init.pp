class tomcat6 ($config_hash = {},) inherits tomcat6::params {
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
  $default_params = [$tomcat6::params::tomcat_user,
  $tomcat6::params::tomcat_group,
  $tomcat6::params::java_opts,
  $tomcat6::params::catalina_pid,
  $tomcat6::params::catalina_base,
  $tomcat6::params::catalina_home,
  $tomcat6::params::jasper_home,
  $tomcat6::params::catalina_tmpdir,
  $tomcat6::params::security_manager,
  $tomcat6::params::shutdown_wait,
  $tomcat6::params::shutdown_verbose]
  $conf_file_content = get_tomcat_conf($default_params, $config_hash)

  package {'tomcat6' :
    ensure => installed,
    require => Notify['start_installation'],
  }

  file {$conf_file :
    ensure	=> present,
    content => $conf_file_content,
    require	=> Package['tomcat6'],
  }

  service {'tomcat6' :
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
    subscribe     => File[${conf_file}],
  }
}
