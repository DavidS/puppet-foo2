# TODO: Define a standard parametrized class
#    
# Class: foo
#
# Usage:
# include foo
#
class foo {

    # Load the variables used in this module. Check the params.pp file 
    require foo::params

    package { "foo":
        name   => "${foo::params::packagename}",
        ensure => present,
    }

    service { "foo":
        name       => "${foo::params::servicename}",
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => "${foo::params::hasstatus}",
        pattern    => "${foo::params::processname}",
        require    => Package["foo"],
        subscribe  => File["foo.conf"],
    }

    file { "foo.conf":
        path    => "${foo::params::configfile}",
        mode    => "${foo::params::configfile_mode}",
        owner   => "${foo::params::configfile_owner}",
        group   => "${foo::params::configfile_group}",
        ensure  => present,
        require => Package["foo"],
        notify  => Service["foo"],
        # How configuration file is managed is define in custom implementations. Here are some examples:
        # source  => [ "puppet://modules/foo/foo.conf--$hostname" , "puppet://modules/foo/foo.conf-$role" , "puppet://modules/foo/foo.conf" ] 
        # content => template("foo/foo.conf.erb"),
        # ...
    }

    # Include OS specific subclasses, if necessary
    case $operatingsystem {
        default: { }
    }

    # Include project specific class if $my_project is set
    if $my_project { include "foo::${my_project}" }

    # Include extended classes, if relevant variables are defined 
    if $puppi == "yes" { include foo::puppi }
    if $monitor == "yes" { include foo::monitor }
    if $firewall == "yes" { include foo::firewall }

    # Include debug class is debugging is enabled ($debug=yes)
    if ( $debug == "yes" ) or ( $debug == true ) { include foo::debug }

}
