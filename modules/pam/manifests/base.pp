class pam::base {
    include pam::multiple_ldap_access
    package { ['pam_ldap','nss_ldap','nscd']: }

    service { 'nscd':
        require => Package['nscd'],
    }

    file {
        '/etc/pam.d/system-auth':
            content => template('pam/system-auth');
        '/etc/nsswitch.conf':
            content => template('pam/nsswitch.conf');
        '/etc/ldap.conf':
            content => template('pam/ldap.conf');
        '/etc/openldap/ldap.conf':
            content => template('pam/openldap.ldap.conf');
    }

    $ldap_password = extlookup("${::fqdn}_ldap_password",'x')
    file { '/etc/ldap.secret':
        mode    => '0600',
        content => $ldap_password
    }
}
