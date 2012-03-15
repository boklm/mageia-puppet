class common::export_ssh_keys {
    @@sshkey { $::fqdn:
        type         => 'rsa',
        key          => $::sshrsakey,
        host_aliases => [$::ipaddress,$::hostname],
    }
}
