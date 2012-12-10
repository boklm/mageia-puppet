class openssh::ssh_keys_from_ldap($symlink_users = [],
                                  $config = '') inherits server {
    # root account authorized_keys will be symlinked
    # if you want to add symlink on other accounts, use $symlink_users parameter

    File ['/etc/ssh/sshd_config'] {
        content => template('openssh/sshd_config','openssh/sshd_config_ldap')
    }

    package { 'python-ldap': }

    include openssh::pubkeys_directory
    $pubkeys_directory = $openssh::pubkeys_directory::pubkeys_directory

    symlink_user { $symlink_users: }

    $ldap_pwfile = '/etc/ldap.secret'
    $ldap_servers = get_ldap_servers()
    mga-common::local_script { 'ldap-sshkey2file.py':
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
