class spamassassin {

    package { "spamassassin", "spamassassin-sa-compile":
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
}
