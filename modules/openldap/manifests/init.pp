class openldap {
    package { 'openldap-servers': }

    service { 'ldap':
        subscribe => Package['openldap-servers'],
        require   => Openssl::Self_signed_cert["ldap.$::domain"],
    }

    exec { '/etc/init.d/ldap check':
        refreshonly => true,
        notify      => Service['ldap'],
    }

    file { '/etc/ssl/openldap/':
        ensure => directory,
    }

    openssl::self_signed_cert{ "ldap.$::domain":
        directory => '/etc/ssl/openldap/',
    }

    openldap::config {
        '/etc/openldap/slapd.conf':
            content => '';
        '/etc/openldap/mandriva-dit-access.conf':
            content => '';
        '/etc/sysconfig/ldap':
            content => '';
    }
}
