class icecream {
    class scheduler {
        package { "icecream-scheduler":
            ensure => installed,
        }

        service { "icecream-scheduler": 
            ensure => running,
            hasstatus => true,
            subscribe => [Package['icecream-scheduler']],
        }
    }

    class client_common {
        package { "icecream":
            ensure => installed,
        }

        service { "icecream": 
            ensure => running,
            hasstatus => true,
            subscribe => [Package['icecream']],
        }    
    }

    define client($host => '') {
        include icecream::client_common
        file { "/etc/sysconfig/icecream":
            ensure => present,
            owner => root,
            group => root,
            mode => 640,
            content => template("icecream/sysconfig"),
        }
    }
}
