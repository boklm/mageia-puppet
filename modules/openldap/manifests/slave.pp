class openldap::slave($rid) inherits openldap {

    @@openldap::exported_slave { $rid: }

    $sync_password = extlookup("ldap_syncuser-$::hostname",'x')

    # same access rights as master
    Openldap::Config['/etc/openldap/mandriva-dit-access.conf'] {
        content => template('openldap/mandriva-dit-access.conf'),
    }

    Openldap::Config['/etc/openldap/slapd.conf'] {
        content => template('openldap/slapd.conf','openldap/slapd.syncrepl.conf'),
    }

    Openldap::Config['/etc/sysconfig/ldap'] {
        content => template('openldap/ldap.sysconfig'),
    }
}
