class postfix {
    package { postfix: }

    service { 'postfix':
        subscribe => Package['postfix'],
    }

    file { '/etc/postfix/main.cf':
        require => Package['postfix'],
        content => '',
        notify  => Service['postfix'],
    }
}
