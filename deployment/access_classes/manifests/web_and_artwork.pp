class access_classes::web_and_artwork {
    pam::multiple_ldap_access { 'web_artwork':
        access_classes => ['mga-web','mga-sysadmin','mga-artwork']
    }
}
