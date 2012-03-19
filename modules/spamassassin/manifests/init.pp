class spamassassin {
    # it should also requires make, bug fixed in cooker
    package { 'spamassassin-sa-compile':
        notify => Exec['sa-compile'],
    }

    package { 'spamassassin': }

    file { '/etc/mail/spamassassin/local.cf':
        require => Package['spamassassin'],
        content => template('spamassassin/local.cf')
    }

    exec { 'sa-compile':
        refreshonly => true,
        require     => [Package['spamassassin-sa-compile'],Package['spamassassin']]
    }
}
