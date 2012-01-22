class openldap {
    define config($content) {
        file { $name:
            require => Package["openldap-servers"],
            content => $content,
            notify => Exec["/etc/init.d/ldap check"],
        }
    }

    class common {
        package { 'openldap-servers': }

        service { ldap:
            subscribe => Package['openldap-servers'],
            require => Openssl::Self_signed_cert["ldap.$domain"],
        }

        exec { "/etc/init.d/ldap check":
            refreshonly => true,
            notify => Service["ldap"],
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

        if $environment == "test" {
            # if we ae in a test vm, we need to fill the directory
            # with data
            local_script { "init_ldap.sh":
                content => template('openldap/init_ldap.sh'),
            }

            exec { "init_ldap.sh":
                # taken arbitrary among all possible files
                creates => "/var/lib/ldap/objectClass.bdb",
                require => Local_script["init_ldap.sh"],
            }
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
