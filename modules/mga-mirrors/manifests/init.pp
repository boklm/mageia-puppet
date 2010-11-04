class mga-mirrors {

    include apache::mod_fcgid

    package { 'mga-mirrors':
        ensure => installed
    }

    # add a apache vhost
    file { "mirrors.$domain.conf":
        path => "/etc/httpd/conf/vhosts.d/$name",
        ensure => "present",
        owner => root,
        group => root,
        mode => 644,
        notify => Service['apache'],
        content => template("mga-mirrors/mirrors_vhost.conf")
    }    
}
