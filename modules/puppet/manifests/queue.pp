class puppet::queue {
    include stompserver

    service { 'puppetqd':
        provider => base,
        start => "/usr/sbin/puppetqd",
        require => [Package['puppet-server'],File['/etc/puppet/puppet.conf']],
    }
}
