class access_classes::web {
    class { pam::multiple_ldap_access:
        access_classes => ['mga-web','mga-sysadmin']
    }
}
