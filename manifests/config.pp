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
	notify  => Exec['tomcat6-restart'],
  }

  exec {'tomcat6-restart':
	command     => "service tomcat6 restart",
	refreshonly => true,
	logoutput   => true,
	path        => '/sbin',
  }

}
