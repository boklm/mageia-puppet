class gitweb {
    package { 'gitweb': }
    # TODO some rpm may be needed ( like perl-FCGI )
    # git >= 17.2 is needed for fastcgi support

    # TODO fix git rpm to show the css, the js, and others missing file

    file { '/etc/gitweb.conf':
        content => template('gitweb/gitweb.conf'),
        notify  => Service['apache'],
        require => Package['gitweb'],
    }

    apache::webapp_other { 'gitweb':
        webapp_file => 'gitweb/webapp.conf',
    }

    local_script { 'gitweb.wrapper.sh':
        content => template('gitweb/wrapper.sh'),
        notify  => Service['apache'],
    }

    apache::vhost_base { "gitweb.$::domain":
        content => template('gitweb/vhost.conf')
    }
}
