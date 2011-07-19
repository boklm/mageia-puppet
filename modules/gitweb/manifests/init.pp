class gitweb {
    package { 'gitweb':
        ensure => installed,
    }
    # TODO some rpm may be needed ( like perl-FCGI )
    # git >= 17.2 is needed for fastcgi support

    # TODO fix git rpm to show the css, the js, and others missing file

    file { 'gitweb.conf':
        ensure => present,
        path => '/etc/gitweb.conf',
        content => template('gitweb/gitweb.conf'),
        notify => Service['apache'],
        require => Package['gitweb']
    }

    file { 'webapps.d/gitweb.conf':
        ensure => present,
        path => '/etc/httpd/conf/webapps.d/gitweb.conf',
        content => template('gitweb/webapp.conf'),
        notify => Service['apache'],
    }
   
    file { 'gitweb.wrapper.sh':
        ensure => present,
        mode => 755,
        path => '/usr/local/bin/gitweb.wrapper.sh',
        content => template('gitweb/wrapper.sh'),
        notify => Service['apache'],
    }
     
    apache::vhost_base { "gitweb.$domain":
        content => template("gitweb/vhost.conf")
    }
}
