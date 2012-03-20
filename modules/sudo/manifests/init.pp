class sudo {
    package { 'sudo': }

    file { '/etc/sudoers.d':
        ensure => directory,
        mode   => '0711',
    }

    file { '/etc/sudoers':
        mode    => '0440',
        content => template('sudo/sudoers'),
    }
}
