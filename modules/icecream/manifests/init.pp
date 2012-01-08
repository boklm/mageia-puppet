class icecream {
    class scheduler {
        package { "icecream-scheduler": }

        service { "icecream-scheduler": 
            ensure => running,
            hasstatus => true,
            subscribe => [Package['icecream-scheduler']],
        }
    }

    class client_common {
        package { "icecream": }

        service { "icecream": 
            ensure => running,
            hasstatus => true,
            subscribe => [Package['icecream']],
        }    
    }

    define client($host => '') {
        include icecream::client_common
        file { "/etc/sysconfig/icecream":
            content => template("icecream/sysconfig"),
        }
    }
}
