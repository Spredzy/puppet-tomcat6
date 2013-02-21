puppet-tomcat6
==============

A puppet module that installs the Tomcat Java Servlet Container

# About

This module installs Tomcat 6 from your package system.

On Entreprise Linux based system, packages are retrieved from JPackage repositories.
By default it will retrieve the packages from JPackage 6.0, if for some reason you want
to get them installed from JPackage 5.0 please edit the module, by doing the following in init.pp

change

    require jpackage

by

    class{'jpackage':
      version => '5.0',
      before  => Package['tomcat6'],
    }

# Usage

Simplest form

    inlcude tomcat6

If you have parameters you wan to specify

    class {'tomcat6':
      java_opts => '',
      lang => 'fr_FR',
      tomcat_user => my_tomcat_user',
    }

# Tests

It has been tested on

* CentOS 5
* CentOS 6
* Debian 6
