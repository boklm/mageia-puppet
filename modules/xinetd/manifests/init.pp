class xinetd {
    package { "xinetd":
        ensure => installed 
    }

    service { xinetd:
        ensure => running,
        path => "/etc/init.d/xinetd",
        subscribe => [ Package["xinetd"] ]
    }
   
    define service($content) {
        include xinetd
        file { "/etc/xinetd.d/$name":
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            require => Package["xinetd"],
            content => $content,
            notify => Service['xinetd']
        }
    }
}
  
