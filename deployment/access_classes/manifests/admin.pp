# for server where only admins can connect
class access_classes::admin {
    class { pam::multiple_ldap_access:
        access_classes => ['mga-sysadmin']
    }
}


