class amavis {

    package { "amavisd-new":
        ensure => installed, 
    }

    service { "amavisd":
        ensure => running,
        path => "/etc/init.d/amavisd",
    }

    file { "/etc/amavisd/amavisd.conf":
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        requires => Package["amavisd-new"],
        content => template('amavis/amavisd.conf')
    }
}
