# TODO create the user for sync in ldap
# this define is mainly syntaxic sugar
define openldap::slave_instance($rid) {
    # seems the inheritance do not work as I believe
    include openldap::common
    class { 'openldap::slave':
        rid => $rid,
    }
}


