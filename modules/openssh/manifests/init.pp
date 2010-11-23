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

 
    class ssh_keys_from_ldap {

        package { 'python-ldap':
            ensure => installed,
        }

        $pubkeys_directory = "/var/lib/pubkeys"
        file { $pubkeys_directory:
            ensure => directory,
            owner => root,
            group => root,
            mode => 755,
        #    before => Class["openssh"] 
        }

        file { "$pubkeys_directory/root":
            ensure => directory,
            owner => root,
            group => root,
            mode => 700,
        }

        file { "$pubkeys_directory/root/authorized_keys":
            ensure => "/root/.ssh/authorized_keys",
            mode => 700,
        }

        $ldap_pwfile = "/etc/ldap.secret"
        file { '/usr/local/bin/ldap-sshkey2file.py':
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template("restrictshell/ldap-sshkey2file.py"),
            require => Package['python-ldap']
        }
    } 
}
