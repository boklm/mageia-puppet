class stompserver {
    package { 'stompserver': }

    service { 'stompserver':
        require => Package['stompserver'],
    }
}
