class common::i18n {
    package { 'locales-en': }

    # push the locale everywhere, as it affect facter
    file { '/etc/sysconfig/i18n':
        content => template('common/i18n'),
    }
}
