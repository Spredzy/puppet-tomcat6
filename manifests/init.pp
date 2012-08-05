class tomcat6  inherits tomcat6::params {

    if $osfamily == "RedHat" {

      package {'yum-priorities' :
        ensure    => installed,
      }

      Exec { path =>  ["/bin", "/usr/bin"], require => Package['yum-priorities'],}
      exec {
        "rpm -Uvh $epel_url" :
          before  => Exec["rpm -Uvh $rpmforge_url"],
          unless  => "rpm -qa | grep epel-release";
        "rpm -Uvh $rpmforge_url" :
          before  => Exec["wget http://jpackage.org/jpackage50.repo"],
          unless  => "rpm -qa | grep rpmforge-release";
        "wget http://jpackage.org/jpackage50.repo" :
          cwd     => "/etc/yum.repos.d/",
          unless  => "ls -la /etc/yum.repos.d/ | grep jpackage";
      }

      #
      # The following two statement are there to correct an incorrect behvoir of CentOS 5 Series related to JPackage.
      # TODO Check if this applies also for CentOS 6 Series
      # Missing Dependency: /usr/bin/rebuild-security-providers is needed by package java-1.4.2-gcj-compat-1.4.2.0-40jpp.115.i386 (base)
      #

      exec {'rpm -Uvh http://plone.lucidsolutions.co.nz/linux/centos/images/jpackage-utils-compat-el5-0.0.1-1.noarch.rpm' :
        path    => ["/usr/bin", "/bin"],
        require => Exec["wget http://jpackage.org/jpackage50.repo"],
	      before  => Notify["start_installation"],
        unless  => "rpm -qa | grep jpackage-utils-compat-el5-0.0.1-1";
      }

      #
      #

      $packages = ['tomcat6', 'tomcat6-admin-webapps']
    } elsif $osfamily == "Darwin" {
      $packages = ['tomcat6']
    } elsif $osfamily == "Debian" {
      $packages = ['tomcat6', 'tomcat6-admin']
    }

   notify {"start_installation" : }

    package {[$packages] :
      ensure => installed,
      require => Notify["start_installation"],
    }

     service {'tomcat6' :
      ensure      => running,
      enable      => true,
      hasrestart  => true,
      hasstatus   => true,
      require     => Package["tomcat6"],
    }
}
