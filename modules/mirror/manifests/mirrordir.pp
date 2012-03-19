define mirror::mirrordir ($remoteurl,
                          $localdir,
                          $rsync_options='-avH --delete') {
    include mirror::base
    $lockfile = "$mirror::base::locksdir/$name"

    file { $localdir:
        ensure => directory,
        owner  => 'mirror',
        group  => 'mirror',
    }

    local_script { "mirror_$name":
        content => template('mirror/mirrordir'),
    }

    cron { "mirror_$name":
        user    => mirror,
        minute  => '*/10',
        command => "/usr/local/bin/mirror_$name",
        require => Local_script["mirror_$name"],
    }
}
