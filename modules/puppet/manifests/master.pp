class puppet::master inherits puppet {
    include puppet::client
    include puppet::queue
    include puppet::stored_config
    include puppet::hiera

    package { ["ruby-$puppet::stored_config::database", 'ruby-rails']: }

    File['/etc/puppet/puppet.conf'] {
        content => template('puppet/puppet.conf',
                            'puppet/puppet.agent.conf',
                            'puppet/puppet.master.conf'),
    }


    # rails and sqlite3 are used for stored config
    package { 'puppet-server': }

    service { 'puppetmaster':
        subscribe => [Package['puppet-server'],
                      File['/etc/puppet/puppet.conf']],
    }

    file { '/etc/puppet/extdata':
        ensure  => directory,
        owner   => puppet,
        group   => puppet,
        mode    => '0700',
        recurse => true,
    }

    file { '/etc/puppet/tagmail.conf':
        content => template('puppet/tagmail.conf'),
    }

    tidy { '/var/lib/puppet/reports':
        age     => '4w',
        matches => '*.yaml',
        recurse => true,
        type    => 'mtime',
    }

    file { '/etc/puppet/autosign.conf':
        ensure  => $::environment ? {
                    'test'  => 'present',
                    default => 'absent',
        },
        content => '*',
    }
}
