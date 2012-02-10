class shadow {
    file { '/etc/login.defs':
        owner  => 'root',
        group  => 'shadow',
        mode   => '0640',
        source => 'puppet:///modules/shadow/login.defs',
    }
}
