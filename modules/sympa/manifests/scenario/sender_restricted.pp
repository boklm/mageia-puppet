define sympa::scenario::sender_restricted(
    $email      = false,
    $ldap_group = false
) {
    file { "/etc/sympa/scenari/send.restricted_$name":
        content => template('sympa/scenari/sender.restricted')
    }
}
