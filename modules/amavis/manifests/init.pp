class amavis {

    package { "amavisd-new":
        ensure => installed, 
    }

    service { "amavisd":
        ensure => running,
        path => "/etc/init.d/amavisd",
        subscribe  => Package["amavisd-new"],
    }

    file { "/etc/amavisd/amavisd.conf":
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["amavisd-new"],
        content => template('amavis/amavisd.conf')
    }
}
