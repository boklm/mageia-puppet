class postfix {
    # some trick to manage daemon directory, who is arch dependent on mdv    
    $usr_lib = $architecture ? {
        x86_64 => "lib64",
        default => "lib"
    }

    $path_daemon_directory = "/usr/$usr_lib/postfix/"


    class postfix_base {
        package { postfix:
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


    class postfix_simple_relay inherits postfix_base {
        file { '/etc/postfix/main.cf':
            content => template("postfix/simple_relay_main.conf"),
        }
    }
}
