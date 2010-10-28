class openldap {
    class base {
        package { 'openldap-servers':
            ensure => installed 
        }

        service { ldap:
            ensure => running,
            subscribe => [ Package['openldap-servers']],
            path => "/etc/init.d/ldap"
        }
    }

    # /etc/
    # 11:57:48|  blingme> misc: nothing special, just copy slapd.conf, mandriva-dit-access.conf across, slapcat one side, slapadd other side

    file { '/etc/openldap/slapd.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["openldap-servers"],
        content => "",
        notify => [Service['ldap']]
    }

    file { '/etc/openldap/mandriva-dit-access.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["openldap-servers"],
        content => "",
        notify => [Service['ldap']]
    }

    class master inherits base {
        file { '/etc/openldap/mandriva-dit-access.conf':
            content => template("openldap/mandriva-dit-access.conf"),
        }

        file { '/etc/openldap/slapd.conf':
            content => template("bind/slapd.conf"),
        }
    }
}
