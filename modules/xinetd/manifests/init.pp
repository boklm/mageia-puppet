class xinetd {
    package { "xinetd": }

    service { xinetd:
        subscribe => Package["xinetd"]
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
  
