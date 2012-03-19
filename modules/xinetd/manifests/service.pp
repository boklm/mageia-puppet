define xinetd::service($content) {
    include xinetd
    file { "/etc/xinetd.d/$name":
        require => Package['xinetd'],
        content => $content,
        notify  => Service['xinetd']
    }
}

