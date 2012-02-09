class puppet::queue {
    include stompserver

    package { 'ruby-stomp': }

    service { 'puppetqd':
        provider => base,
        start => "/usr/sbin/puppetqd",
        require => [Package['puppet-server'],
                    Package['ruby-stomp'],
                    File['/etc/puppet/puppet.conf']],
    }
}
