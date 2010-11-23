class spamassassin {

    package { "spamassassin-sa-compile":
        ensure => installed,
        notify => "sa-compile",
    }

    package { "spamassassin":
        ensure => installed, 
    }

    file { "/etc/mail/spamassassin/local.cf":
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        requires => Package["spamassassin"],
        content => template('spamassassin/local.cf')
    }

    exec { "sa-compile":
        refreshonly => true,
    }
}
