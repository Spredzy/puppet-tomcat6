class tomcat6::config ($config_hash = {}) inherits tomcat6::params {

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

  file {$conf_file :
    ensure  => present,
    content => $conf_file_content,
    notify  => Exec["curl --silent --show-error -I http://localhost:8080 | grep 'Coyote'"],
  }

  # This kind of suck but in order to avoid race condition on tomcat restart it is necessary
  # I did not find any other way to bypass it, if you have an idea hit me up on GitHub
  exec {"curl --silent --show-error -I http://localhost:8080 | grep 'Coyote'" :
    path        => '/usr/sbin:/sbin:/usr/bin:/bin',
    refreshonly => true,
    tries       => 10,
    try_sleep   => 3,
    notify      => Exec['tomcat6-restart'],
  }

  exec {'tomcat6-restart':
    command     => "service tomcat6 restart",
    refreshonly => true,
    logoutput   => true,
    path        => '/usr/sbin:/sbin:/usr/bin:/bin',
  }

}
