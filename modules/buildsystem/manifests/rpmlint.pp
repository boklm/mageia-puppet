class buildsystem::rpmlint {
    $sched_login = $buildsystem::base::sched_login

    package { 'rpmlint': }

    file { '/etc/rpmlint/config':
        require => Package['rpmlint'],
        content => template('buildsystem/rpmlint.conf')
    }

    # directory that hold configuration auto extracted after upload
    # of the rpmlint policy
    # should belong to the scheduler user, as it need to write to it
    file { '/etc/rpmlint/extracted.d/':
        ensure  => directory,
        require => Package['rpmlint'],
        owner   => $sched_login,
    }
}
