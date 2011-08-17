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

        file { '/etc/postfix/main.cf':
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            require => Package["postfix"],
            content => "",
            notify => [Service['postfix']],
        }
    }


    class simple_relay inherits base {
        File['/etc/postfix/main.cf'] {
            content => template("postfix/simple_relay_main.cf"),
        }
    }

    class smtp_server inherits base {
        include postgrey
        include amavis
        include spamassassin
        File['/etc/postfix/main.cf'] {
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

        package { "postfix-ldap":
            ensure => installed
        }
        # council is here until we fully decide who has aliases in com team, 
        # see https://bugs.mageia.org/show_bug.cgi?id=1345 
        # alumini is a special group for tracking previous members of
        # the project, so they keep their aliases for a time
        $aliases_group = ['mga-founders','mga-packagers',
                          'mga-sysadmin','mga-council',
                          'mga-alumni',
                         ]        
        $ldap_password = extlookup("postfix_ldap",'x')
        file { '/etc/postfix/ldap_aliases.conf':
            ensure => present,
            owner => root, 
            group => root, 
            mode => 644, 
            content => template("postfix/ldap_aliases.conf"),
        }

        # TODO merge the file with the previous one, for common part (ldap, etc)
        file { '/etc/postfix/group_aliases.conf':
            ensure => present,
            owner => root, 
            group => root, 
            mode => 644, 
            content => template("postfix/group_aliases.conf"),
        }

        # TODO make it conditional to the presence of sympa
        file { '/etc/postfix/sympa_aliases':
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            content => template("postfix/sympa_aliases"),
        }




        file { '/etc/postfix/virtual_aliases':
            ensure => present,
            owner => root, 
            group => root, 
            mode => 644, 
            content => template("postfix/virtual_aliases"),
        }

        exec { "postmap /etc/postfix/virtual_aliases":
            refreshonly => true,
            subscribe => File['/etc/postfix/virtual_aliases'],
        }
    }


    class secondary_smtp inherits smtp_server {
    }

}
