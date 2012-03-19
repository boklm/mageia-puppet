class openssh {
    # root account authorized_keys will be symlinked
    # if you want to add symlink on other accounts, use $symlink_users parameter
    class ssh_keys_from_ldap($symlink_users = [],
                             $config = '') inherits server {

        File ['/etc/ssh/sshd_config'] {
            content => template('openssh/sshd_config','openssh/sshd_config_ldap')
        }

        package { 'python-ldap': }

        $pubkeys_directory = '/var/lib/pubkeys'
        file { $pubkeys_directory:
            ensure => directory,
        }

        file { "$pubkeys_directory/root":
            ensure => directory,
            mode   => '0700',
        }

        file { "$pubkeys_directory/root/authorized_keys":
            ensure => link
            target => "/root/.ssh/authorized_keys",
            mode   => '0700',
        }

        define symlink_user() {
            file { "$pubkeys_directory/$name":
                ensure => directory,
                owner  => $name,
                group  => $name,
                mode   => '0700',
            }

            file { "$pubkeys_directory/$name/authorized_keys":
                # FIXME : fragile approximation for $HOME
                ensure => link,
                target => "/home/$name/.ssh/authorized_keys",
                mode   => '0700',
            }
        }

        symlink_user { $symlink_users: }

        $ldap_pwfile = '/etc/ldap.secret'
        $ldap_servers = get_ldap_servers()
        local_script { 'ldap-sshkey2file.py':
            content => template('openssh/ldap-sshkey2file.py'),
            require => Package['python-ldap']
        }

        cron { 'sshkey2file':
            command     => '/usr/local/bin/ldap-sshkey2file.py',
            hour        => '*',
            minute      => '*/10',
            user        => 'root',
            environment => 'MAILTO=root',
            require     => Local_script['ldap-sshkey2file.py'],
        }
    }
}
