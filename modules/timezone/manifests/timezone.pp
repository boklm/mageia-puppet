define timezone::timezone() {
    file { '/etc/localtime':
        ensure => link,
        target => "/usr/share/zoneinfo/$name"
    }
}
