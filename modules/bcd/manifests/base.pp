class bcd::base {
    include sudo
    include bcd 

    group { $bcd::login: }

    user { $bcd::login:
        home       => $bcd::home,
        managehome => true,
        comment    => 'User for creating ISOs',
    }

    file { $bcd::public_isos:
        ensure => directory,
        owner  => $bcd::login,
        group  => $bcd::login,
        mode   => '0755',
    }

    # svn version is used for now
    #package { bcd: }

    $isomakers_group = 'mga-iso_makers'
    sudo::sudoers_config { 'bcd':
        content => template('bcd/sudoers.bcd')
    }

    file { '/var/lib/bcd':
        ensure => directory,
        owner => $bcd::login,
        group => $bcd::login,
        mode => '0755',
    }
}

