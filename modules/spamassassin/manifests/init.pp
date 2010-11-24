class spamassassin {

    package { "spamassassin-sa-compile":
        ensure => installed,
        notify => Exec["sa-compile"],
    }

    package { "spamassassin":
        ensure => installed, 
    }

    file { "/etc/mail/spamassassin/local.cf":
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["spamassassin"],
        content => template('spamassassin/local.cf')
    }

    exec { "sa-compile":
        refreshonly => true,
        require => Package["spamassassin-sa-compile"],
    }
}
