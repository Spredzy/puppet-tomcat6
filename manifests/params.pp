class tomcat6::params {

  case $::osfamily {
    'RedHat' : {
      $tomcat_user = 'tomcat'
      $tomcat_settings = '/etc/sysconfig/tomcat6'
    }
    'Debian' : {
      $tomcat_user = 'tomcat6'
      $tomcat_settings = '/etc/default/tomcat6'
    }
    default : {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat Debian")
    }
  }
}
