class postfix::server inherits postfix {
    include postgrey
    include amavis
    include spamassassin

    File['/etc/postfix/main.cf'] {
        content => template('postfix/main.cf'),
    }

    file { '/etc/postfix/transport_regexp':
        content => template('postfix/transport_regexp'),
    }
}
