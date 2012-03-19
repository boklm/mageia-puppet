class mirror::base {
    $locksdir = '/home/mirror/locks'

    file { $locksdir:
        ensure => directory,
        owner  => 'mirror',
        group  => 'mirror',
    }

    group { 'mirror': }

    user { 'mirror':
        comment => 'System user use to run mirror scripts',
        gid     => 'mirror',
    }
}
