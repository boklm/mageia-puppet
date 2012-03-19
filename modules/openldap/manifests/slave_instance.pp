# TODO create the user for sync in ldap
# this define is mainly syntaxic sugar
define openldap::slave_instance($rid) {
    include openldap
    class { 'openldap::slave':
        rid => $rid,
    }
}


