class openssh {

    # some trick to manage sftp server, who is arch dependent on mdv    
    $path_to_sftp = "$lib_dir/ssh/"

    package { "openssh-server":
        ensure => installed
    }

    service { sshd:
        ensure => running,
        path => "/etc/init.d/sshd",
        subscribe => [ Package["openssh-server"], File["sshd_config"] ]
    }

    file { "sshd_config":
        path => "/etc/ssh/sshd_config",
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["openssh-server"],
        content => template("openssh/sshd_config")
    }
}
