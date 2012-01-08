class xinetd {
    package { "xinetd": }

    service { xinetd:
        ensure => running,
        path => "/etc/init.d/xinetd",
        subscribe => [ Package["xinetd"] ]
    }

    define service($content) {
        include xinetd
        file { "/etc/xinetd.d/$name":
            require => Package["xinetd"],
            content => $content,
            notify => Service['xinetd']
        }
    }
}
  
