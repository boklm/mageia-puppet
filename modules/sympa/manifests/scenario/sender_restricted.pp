define sympa::scenario::sender_restricted(
    $email            = false,
    $ldap_group       = false,
    $allow_subscriber = false
) {
    file { "/etc/sympa/scenari/send.restricted_$name":
        content => template('sympa/scenari/sender.restricted')
    }
}
