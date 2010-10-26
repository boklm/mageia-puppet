
class timezone {
    file { "/etc/localetime": 
        ensure => "/usr/share/zoneinfo/$name" 
    }
}
