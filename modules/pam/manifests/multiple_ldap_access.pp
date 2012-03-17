define pam::multiple_ldap_access($access_classes, $restricted_shell = false) {
    if $restricted_shell {
        include restrictshell
    }
    include pam::base
}
