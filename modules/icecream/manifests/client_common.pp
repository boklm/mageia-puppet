class icecream::client_common {
    package { 'icecream': }

    service { 'icecream':
        subscribe => Package['icecream'],
    }
}
