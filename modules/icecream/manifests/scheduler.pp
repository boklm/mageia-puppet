class icecream::scheduler {
    package { 'icecream-scheduler': }

    service { 'icecream-scheduler':
        subscribe => Package['icecream-scheduler'],
    }
}
