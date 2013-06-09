class cgit {
    package { 'cgit': }

    file { '/etc/cgitrc':
        content => template('cgit/cgitrc'),
        notify  => Service['apache'],
        require => Package['cgit'],
    }

    apache::webapp_other { 'cgit':
        webapp_file => 'cgit/webapp.conf',
    }

    mga-common::local_script { 'cgit.filter.commit-links.sh':
        content => template('cgit/filter.commit-links.sh'),
    }

    apache::vhost::base { "gitweb.$::domain":
        content => template('cgit/vhost.conf')
    }
}
