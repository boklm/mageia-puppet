class openssh {
    class server {
        # some trick to manage sftp server, who is arch dependent on mdv    
        $path_to_sftp = "$lib_dir/ssh/"

        package { "openssh-server":
            ensure => installed
        }

        service { sshd:
            ensure => running,
            path => "/etc/init.d/sshd",
            subscribe => [ Package["openssh-server"] ]
        }


        file { "/etc/ssh/sshd_config":
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            require => Package["openssh-server"],
            content => template("openssh/sshd_config"),
            notify => Service["sshd"]
        }
    }

    # root account authorized_keys will be symlinked
    # if you want to add symlink on other accounts, use $symlink_users parameter
    class ssh_keys_from_ldap($symlink_users = []) inherits server {

        File ["/etc/ssh/sshd_config"] {
            content => template("openssh/sshd_config","openssh/sshd_config_ldap")
        }

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

	if $symlink_users {
	    file { "$pubkeys_directory/$symlink_users":
		ensure => directory,
		owner => $symlink_users,
		group => $symlink_users,
		mode => 700,
	    }

	    file { "$pubkeys_directory/$symlink_users/authorized_keys":
		ensure => "/home/$symlink_users/.ssh/authorized_keys",
		mode => 700,
	    }
	}

	$sshkey2file = "/usr/local/bin/ldap-sshkey2file.py"
        $ldap_pwfile = "/etc/ldap.secret"
        file { $sshkey2file:
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template("restrictshell/ldap-sshkey2file.py"),
            require => Package['python-ldap']
        }
        cron { 'sshkey2file':
            command => $sshkey2file,
            hour => "*",
            minute => "*/10",
            user => root,
            environment => "MAILTO=root",
	    require => File[$sshkey2file],
        }
    } 
}
