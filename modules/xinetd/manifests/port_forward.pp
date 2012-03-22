define xinetd::port_forward($target_ip, $target_port, $port, $proto = 'tcp') {
    include xinetd
    file { "/etc/xinetd.d/$name":
        require => Package['xinetd'],
        content => template('xinetd/port_forward'),
        notify  => Service['xinetd']
    }
}
