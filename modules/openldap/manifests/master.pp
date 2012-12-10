class openldap::master inherits openldap {
    Openldap::Config['/etc/openldap/mandriva-dit-access.conf'] {
        content => template('openldap/mandriva-dit-access.conf'),
    }

    $ldap_test_password = extlookup('ldap_test_password','x')
    $ldap_test_directory = '/var/lib/ldap/test'
    file { $ldap_test_directory:
        ensure  => directory,
        group   => 'ldap',
        owner   => 'ldap',
        require => Package['openldap-servers'],
        before  => Service['ldap'],
    }

    Openldap::Config['/etc/openldap/slapd.conf'] {
        content => template('openldap/slapd.conf', 'openldap/slapd.test.conf'),
    }

    Openldap::Config['/etc/sysconfig/ldap'] {
        content => template('openldap/ldap.sysconfig'),
    }

    if $::environment == 'test' {
        # if we are in a test vm, we need to fill the directory
        # with data
        package { 'openldap-clients': }

        mga-common::local_script { 'init_ldap.sh':
            content => template('openldap/init_ldap.sh'),
            require => Package['openldap-clients'],
        }

        exec { 'init_ldap.sh':
            # taken arbitrary among all possible files
            creates => '/var/lib/ldap/objectClass.bdb',
            require => Mga-common::Local_script['init_ldap.sh'],
        }
    }
}
