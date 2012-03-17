class draklive {
    $login = 'draklive'
    $home = '/home/draklive'
    $config = "$home/live-config"
    $var_data = "$home/var-data"
    # TODO merge with bcd
	$isomakers_group = 'mga-iso_makers'

	include sudo

    group { $login: }
 
    user { $login:
        home       => $home,
        comment    => 'User for creating live ISOs',
    }

    package { 'draklive': }

    sudo::sudoers_config { 'draklive':
        content => template('draklive/sudoers.draklive')
    }

	file { $var_data:
	    ensure => directory,
	    owner  => $login,
	    group  => $login,
	    mode   => '0755',
	}

	file { '/var/lib/draklive':
	     ensure => symlink,
	     target => $var_data,
	}

    subversion::snapshot { $config:
        source => "svn://svn.$::domain/soft/images-config/draklive/trunk/",
    }

    cron { 'build live images':
        command => "$config/tools/build_live.sh",
        user    => $login,
        hour    => '4',
        minute  => '30',
    }

    file { '/usr/local/bin/clean-live.sh':
        mode   => '0755',
        source => 'puppet:///modules/draklive/clean-live.sh',
    }
    
    cron { 'clean live build data':
        command => '/usr/local/bin/clean-live.sh',
        hour    => '4',
        minute  => '20',
    }
}
