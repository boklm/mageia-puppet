define sympa::scenario::sender_ldap_group {
    file { "/etc/sympa/scenari/send.restricted_$name":
        content => template('sympa/scenari/sender.ldap_group')
    }
}


