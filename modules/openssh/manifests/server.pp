class openssh::server {
    # some trick to manage sftp server, who is arch dependent on mdv
    $path_to_sftp = "$::lib_dir/ssh/"

    package { 'openssh-server': }

    service { 'sshd':
        subscribe => Package['openssh-server'],
    }

    file { '/etc/ssh/sshd_config':
        require => Package['openssh-server'],
        content => template('openssh/sshd_config'),
        notify  => Service['sshd']
    }
}
