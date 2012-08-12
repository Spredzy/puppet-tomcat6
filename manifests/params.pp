class tomcat6::params {

  #
  # Distribution informations
  #
  # $architecure and $lsbmajdistrelease comes from facter
  #

  $arch       = $architecture
  $el_version = $lsbmajdistrelease

  #
  # Extra package needed for installing tomcat6 informations
  #
	$epel_release =  $lsbmajdistrelease ? {
		'5'	=> '5-4',
		'6'	=> '6-7',	
	}
	$arch_bis = $lsbmajdistrelease ? {
		'6'	=> $arch ? {'i386' => 'i686', default => $arch,},
		default	=> $arch,
	}
  $epel_url       = "http://mirror.uv.es/mirror/fedora-epel//${el_version}/${arch}/epel-release-${epel_release}.noarch.rpm"
  $rpmforge_version   = '0.5.2-2'
  $rpmforge_url     = "http://apt.sw.be/redhat/el${el_version}/en/${arch}/rpmforge/RPMS/rpmforge-release-${rpmforge_version}.el${el_version}.rf.${arch_bis}.rpm"

	#
	# Tomcat6 configuration file parameters
	#
	# EL : /usr/share/tomcat6/conf/tomcat6.conf
	#
	# Debian : /etc/default/tomcat6
	#

	case $osfamily {
		"RedHat" : {
			$conf_file			=	'/usr/share/tomcat6/conf/tomcat6.conf'
			$tomcat_user		=	{'TOMCAT_USER'		=> 'tomcat'}
			$tomcat_group		=	{'TOMCAT_GROUP'		=> 'tomcat'}
			$java_opts			=	{'JAVA_OPTS'		=> '-Xms128m -Xmx1g'}
			$catalina_pid		=	{'CATALINA_PID'		=> '/var/run/tomcat6.pid'}
			$catalina_base		=	{'CATALINA_BASE'	=> '/usr/share/tomcat6'}
			$catalina_home		=	{'CATALINA_HOME'	=> '/usr/share/tomcat6'}
			$jasper_home		=	{'JASPER_HOME'		=> '/usr/share/tomcat6'}
			$catalina_tmpdir	=	{'CATALINA_TMPDIR'	=> '/var/cache/tomcat6/temp'}
			$security_manager	=	{'SECURITY_MANAGER'	=>	'false'}
			$shutdown_wait		=	{'SHUTDOWN_WAIT'	=>	'30'}
			$shutdown_verbose	=	{'SHUTDOWN_VERBOSE'	=>	'false'}
		}
		"Debian" : {
			$conf_file			=	'/etc/default/tomcat6'
			$tomcat_user		=	{'TOMCAT6_USER'		=> 'tomcat6'}
			$tomcat_group		=	{'TOMCAT6_GROUP'	=> 'tomcat6'}
			$java_opts			=	{'JAVA_OPTS'		=> '-Xms128m -Xmx1g'}
			$catalina_pid		=	{'CATALINA_PID'		=> '/var/run/tomcat6.pid'}
			$catalina_base		=	{'CATALINA_BASE'	=> '/var/lib/tomcat6'}
			$catalina_home		=	{'CATALINA_HOME'	=> '/usr/share/tomcat6'}
			$jasper_home		=	{'JASPER_HOME'		=> '/usr/share/tomcat6'}
			$catalina_tmpdir	=	{'CATALINA_TMPDIR'	=> '/var/cache/tomcat6/temp'}
			$security_manager	=	{'SECURITY_MANAGER'	=>	'false'}
			$shutdown_wait		=	{'SHUTDOWN_WAIT'	=>	'30'}
			$shutdown_verbose	=	{'SHUTDOWN_VERBOSE'	=>	'false'}
		}
		default : {
			fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat Debian")
		}
	}


}
