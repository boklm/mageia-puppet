
class timezone {
    file { "/etc/localtime": 
        ensure => "/usr/share/zoneinfo/$name" 
    }
}
