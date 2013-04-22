define sympa::scenario::sender_email($email) {
    file { "/etc/sympa/scenari/send.restricted_$name":
        content => template('sympa/scenari/sender.email')
    }
}
