class access_classes::web_and_artwork {
    class { pam::multiple_ldap_access:
        access_classes => ['mga-web','mga-sysadmin','mga-artwork']
    }
}
