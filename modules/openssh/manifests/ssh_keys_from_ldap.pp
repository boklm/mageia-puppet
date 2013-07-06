class openssh::ssh_keys_from_ldap($config = '') inherits server {
    package { 'python-ldap': }

    $ldap_pwfile = '/etc/ldap.secret'
    $ldap_servers = get_ldap_servers()
    mga_common::local_script { 'ldap-sshkey2file.py':
        content => template('openssh/ldap-sshkey2file.py'),
        require => Package['python-ldap']
    }

    cron { 'sshkey2file':
        command     => '/usr/local/bin/ldap-sshkey2file.py',
        hour        => '*',
        minute      => '*/10',
        user        => 'root',
        environment => 'MAILTO=root',
        require     => Mga_common::Local_script['ldap-sshkey2file.py'],
    }
}
