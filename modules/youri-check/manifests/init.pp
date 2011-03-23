class youri-check {

    $user = 'youri'
    $home = '/var/tmp/youri'
    $outdir = "$home/www"
    $config = "/etc/youri/cauldron.conf"

    user { $user:
	comment => "Youri Check",
	ensure => present,
	managehome => true,
	home => $home,
    }

    package { ['perl-Youri-Media', 'youri-check', 'perl-DBD-SQLite'] :
        ensure => installed
    }

    cron { 'check':
       command => "youri-check -c $config test && youri-check -c $config report",
       hour => 6,
    }

    file { "$config":
       ensure => present,
       owner => $user,
       mode => 640,
       content => template("youri_check/check.conf"),
    }
}
