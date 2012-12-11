class access_classes::iso_makers {
    class { pam::multiple_ldap_access:
        access_classes => ['mga-iso_makers','mga-sysadmin']
    }
}
