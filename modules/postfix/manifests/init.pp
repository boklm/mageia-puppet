class postfix {

    class base {
        package { postfix:
            ensure => installed
        }
    	package { 'nail':
                ensure => installed
        }
        service { postfix:
            ensure => running,
            subscribe => [ Package['postfix']],
            path => "/etc/init.d/postfix"
        }
    }    

    file { '/etc/postfix/main.cf': 
        ensure => present, 
        owner => root, 
        group => root, 
        mode => 644, 
        require => Package["postfix"], 
        content => "", 
        notify => [Service['postfix']] 
    } 


    class simple_relay inherits base {
        file { '/etc/postfix/main.cf':
            content => template("postfix/simple_relay_main.cf"),
        }
    }

    class primary_smtp inherits base {
        file { '/etc/postfix/main.cf':
            content => template("postfix/primary_main.cf"),
        }

        file { '/etc/postfix/master.cf':
            content => template("postfix/primary_master.cf"),
        }
    }

    class secondary_smtp inherits base {
        file { '/etc/postfix/main.cf':
            content => template("postfix/secondary_main.cf"),
        }
    }

}
