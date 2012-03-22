class postfix {
    package { ['postfix', 'nail']: }

    service { 'postfix':
        subscribe => Package['postfix'],
    }

    file { '/etc/postfix/main.cf':
        require => Package['postfix'],
        content => '',
        notify  => Service['postfix'],
    }
}
