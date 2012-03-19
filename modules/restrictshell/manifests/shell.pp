class restrictshell::shell {
    file { '/etc/membersh-conf.d':
        ensure => directory,
    }

    local_script { 'sv_membersh.pl':
        content => template('restrictshell/sv_membersh.pl'),
    }

    file { '/etc/membersh-conf.pl':
        mode    => '0755',
        content => template('restrictshell/membersh-conf.pl'),
    }
}
