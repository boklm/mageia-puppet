define sympa::scenario::sender_email {
    $sender_email_file = regsubst($name,'\@','-at-')
    file { "/etc/sympa/scenari/send.restricted_$sender_email_file":
        content => template('sympa/scenari/sender.email')
    }
}
