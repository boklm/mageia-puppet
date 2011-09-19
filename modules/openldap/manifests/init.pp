class openldap {
    class common {
        package { 'openldap-servers':
            ensure => installed 
        }

        service { ldap:
            ensure => running,
            subscribe => [ Package['openldap-servers']],
            require => [ Openssl::Self_signed_cert["ldap.$domain"]],
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
    }

    class master inherits common {
        File['/etc/openldap/mandriva-dit-access.conf'] {
            content => template("openldap/mandriva-dit-access.conf"),
        }

        $ldap_test_password = extlookup("ldap_test_password",'x')
        $ldap_test_directory = "/var/lib/ldap/test"
        file { "$ldap_test_directory":
            ensure => directory,
            group => ldap,
            owner => ldap,
            mode => 644,
            require => Package["openldap-servers"],
            before => Service['ldap'],
        }       
 
        File['/etc/openldap/slapd.conf'] {
            content => template("openldap/slapd.conf", "openldap/slapd.test.conf"),
        }

        File['/etc/sysconfig/ldap'] {
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
        File['/etc/openldap/mandriva-dit-access.conf'] {
            content => template("openldap/mandriva-dit-access.conf"),
        }

        File['/etc/openldap/slapd.conf'] {
            content => template("openldap/slapd.conf",'openldap/slapd.syncrepl.conf'),
        }

        File['/etc/sysconfig/ldap'] {
            content => template("openldap/ldap.sysconfig"),
        }
    }
}
