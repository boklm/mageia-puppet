class postfix::simple_relay inherits postfix {
    File['/etc/postfix/main.cf'] {
        content => template('postfix/simple_relay_main.cf'),
    }
}
