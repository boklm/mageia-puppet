class xinetd {
    package { 'xinetd': }

    service { 'xinetd':
        subscribe => Package['xinetd']
    }
}
