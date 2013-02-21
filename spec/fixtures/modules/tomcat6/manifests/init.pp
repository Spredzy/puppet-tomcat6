class tomcat6 (
  $tomcat_user = '',
  $java_opts = '-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC',
  $lang = 'en_US') {

  include tomcat6::params

  Package['tomcat6'] -> File[$tomcat6::params::tomcat_settings] -> Service['tomcat6']

  if $tomcat_user == '' {
    $tomcat_user_internal = $tomcat6::params::tomcat_user
  } else {
    $tomcat_user_internal = $tomcat_user
  }

  if $::osfamily == 'RedHat' {
    require jpackage
  }

  package {'tomcat6' :
    ensure => installed,
  }

  file {$tomcat6::params::tomcat_settings :
    ensure  => present,
    content => template('tomcat6/tomcat6.erb'),
  }

  service {'tomcat6' :
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

}
