
class timezone {
    define timezone() {
        file { "/etc/localtime": 
            ensure => "/usr/share/zoneinfo/$name" 
        }
    }
}
