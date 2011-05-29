class openldap {
    class common {
        package { 'openldap-servers':
            ensure => installed 
        }

        service { ldap:
            ensure => running,
            subscribe => [ Package['openldap-servers']],
            path => "/etc/init.d/ldap"
        }

        file {"/etc/ssl/openldap/":
            ensure => directory,
            owner => root,
            group => root,
            mode => 755,
        }

        openssl::self_signed_cert{ "ldap.$domain":
            directory => "/etc/ssl/openldap/"
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

    file { '/etc/sysconfig/ldap':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["openldap-servers"],
        content => "",
        notify => [Service['ldap']]
    } 

    class master inherits common {
        file { '/etc/openldap/mandriva-dit-access.conf':
            content => template("openldap/mandriva-dit-access.conf"),
        }

        $ldap_test_password = extlookup("ldap_test_password",'x')
        $ldap_test_directory = "/var/lib/ldap/test"
        file { "$ldap_test_directory":
            ensure => directory,
            group => ldap,
            owner => ldap,
            mode => 644,
        }       
 
        file { '/etc/openldap/slapd.conf':
            content => template("openldap/slapd.conf", "openldap/slapd.test.conf"),
        }

        file { '/etc/sysconfig/ldap':
            content => template("openldap/ldap.sysconfig"),
        }
    }
}
