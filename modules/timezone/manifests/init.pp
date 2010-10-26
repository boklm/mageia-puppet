define timezone() {
    file { "/etc/localetime": 
        ensure => link, 
        target => "/usr/share/zoneinfo/$name" 
    }
}
