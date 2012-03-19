class ssmtp {
    package { 'ssmtp': }

    file { '/etc/ssmtp/ssmtp.conf':
        content => template('ssmtp/ssmtp.conf')
    }
}
