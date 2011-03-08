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

    class smtp_server inherits base {
        include postgrey
        include amavis
        include spamassassin
        file { '/etc/postfix/main.cf':
            content => template("postfix/main.cf"),
        }

        file { '/etc/postfix/transport_regexp':
            ensure => present,
            owner => root, 
            group => root, 
            mode => 644, 
            content => template("postfix/transport_regexp"),
        }

    }

    class primary_smtp inherits smtp_server {
        file { '/etc/postfix/master.cf':
            ensure => present,
            owner => root, 
            group => root, 
            mode => 644, 
            content => template("postfix/primary_master.cf"),
        }


        $aliases_group = ['mga-founders']        
        $ldap_password = extlookup("postfix_ldap",'x')
        file { '/etc/postfix/ldap_aliases.conf':
            ensure => present,
            owner => root, 
            group => root, 
            mode => 644, 
            content => template("postfix/ldap_aliases.conf"),
        }
    }

    class secondary_smtp inherits smtp_server {
    }

}
