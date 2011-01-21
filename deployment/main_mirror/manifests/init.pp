class main_mirror {
    $mirror = "/distrib"
    file { "$mirror":
        ensure => directory,
    }

    file { "$mirror/README":
        ensure => present,
        source => "puppet:///modules/main_mirror/README"         
    }

    file { "$mirror/mirror":
        ensure => directory,

    }

    file { "$mirror/mirror/README.mirroring":
        ensure => present,
        source => "puppet:///modules/main_mirror/mirror/README.mirroring"         
    }

    file { "$mirror/mirror/README.paths":
        ensure => present,
        source => "puppet:///modules/main_mirror/mirror/README.paths"         
    }


}
