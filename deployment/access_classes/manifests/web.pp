class access_classes::web {
    pam::multiple_ldap_access { 'web':
        access_classes => ['mga-web','mga-sysadmin']
    }
}
