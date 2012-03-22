class access_classes::iso_makers {
    pam::multiple_ldap_access { 'iso_makers':
        access_classes => ['mga-iso_makers','mga-sysadmin']
    }
}
