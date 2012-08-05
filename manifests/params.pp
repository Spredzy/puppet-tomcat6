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
  $epel_release     = '5-4'
  $epel_url       = "http://mirror.uv.es/mirror/fedora-epel//${el_version}/${arch}/epel-release-${epel_release}.noarch.rpm"
  $rpmforge_version   = '0.5.2-2'
  $rpmforge_url     = "http://apt.sw.be/redhat/el${el_version}/en/${arch}/rpmforge/RPMS/rpmforge-release-${rpmforge_version}.el${el_version}.rf.${arch}.rpm"



}
