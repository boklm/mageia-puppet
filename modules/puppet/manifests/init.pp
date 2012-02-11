class puppet {

    package { 'puppet': }

    # only here to be subclassed
    file { '/etc/puppet/puppet.conf':
        require => Package[puppet],
        content => template('puppet/puppet.conf','puppet/puppet.agent.conf'),
    }
}
