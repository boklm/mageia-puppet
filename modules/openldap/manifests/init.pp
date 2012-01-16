class openldap {
    define config($content) {
        file { $name:
            require => Package["openldap-servers"],
            content => $content,
            notify => [Service['ldap']]
        }
    }

    class common {
        package { 'openldap-servers': }

        service { ldap:
            subscribe => Package['openldap-servers'],
            require => Openssl::Self_signed_cert["ldap.$domain"],
        }

        file {"/etc/ssl/openldap/":
            ensure => directory,
        }

        openssl::self_signed_cert{ "ldap.$domain":
            directory => "/etc/ssl/openldap/"
        }

        openldap::config {
            '/etc/openldap/slapd.conf': content => "";
            '/etc/openldap/mandriva-dit-access.conf': content => "";
            '/etc/sysconfig/ldap': content => "";
        } 
    }

    class master inherits common {
        Openldap::Config['/etc/openldap/mandriva-dit-access.conf'] {
            content => template("openldap/mandriva-dit-access.conf"),
        }

        $ldap_test_password = extlookup("ldap_test_password",'x')
        $ldap_test_directory = "/var/lib/ldap/test"
        file { "$ldap_test_directory":
            ensure => directory,
            group => ldap,
            owner => ldap,
            require => Package["openldap-servers"],
            before => Service['ldap'],
        }       
 
        Openldap::Config['/etc/openldap/slapd.conf'] {
            content => template("openldap/slapd.conf", "openldap/slapd.test.conf"),
        }

        Openldap::Config['/etc/sysconfig/ldap'] {
            content => template("openldap/ldap.sysconfig"),
        }
    }

    # TODO create the user for sync in ldap
    # syntaxic sugar 
    define slave_instance($rid) {
        # seems the inheritance do not work as I believe
        include openldap::common
        class { 'openldap::slave':
                    rid => $rid,
        }
    }

    class slave($rid) inherits common {

        $sync_password = extlookup("ldap_syncuser-$hostname",'x')
        
        # same access rights as master
        Openldap::Config['/etc/openldap/mandriva-dit-access.conf'] {
            content => template("openldap/mandriva-dit-access.conf"),
        }

        Openldap::Config['/etc/openldap/slapd.conf'] {
            content => template("openldap/slapd.conf",'openldap/slapd.syncrepl.conf'),
        }

        Openldap::Config['/etc/sysconfig/ldap'] {
            content => template("openldap/ldap.sysconfig"),
        }
    }
}
