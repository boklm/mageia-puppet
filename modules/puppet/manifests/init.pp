class puppet {
    # only here to be subclassed
    file { '/etc/puppet/puppet.conf':
        require => Package[puppet],
    }
}
