# for server where only admins can connect
class access_classes::admin {
    pam::multiple_ldap_access { 'admin':
        access_classes => ['mga-sysadmin']
    }
}


