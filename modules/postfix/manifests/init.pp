class postfix {
    class base {
        package { [postfix,nail]: }

        service { postfix:
            subscribe => Package['postfix'],
        }

        file { '/etc/postfix/main.cf':
            require => Package["postfix"],
            content => "",
            notify => Service['postfix'],
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
            content => template("postfix/transport_regexp"),
        }

    }

    class primary_smtp inherits smtp_server {

        package { "postfix-ldap": }

        # council is here until we fully decide who has aliases in com team, 
        # see https://bugs.mageia.org/show_bug.cgi?id=1345 
        # alumini is a special group for tracking previous members of
        # the project, so they keep their aliases for a time
        $aliases_group = ['mga-founders','mga-packagers',
                          'mga-sysadmin','mga-council',
                          'mga-alumni','mga-i18n-committers',
                         ]        
        $ldap_password = extlookup("postfix_ldap",'x')
        $ldap_servers = get_ldap_servers()

        file {
            '/etc/postfix/master.cf': content => template("postfix/primary_master.cf");
            '/etc/postfix/ldap_aliases.conf': content => template("postfix/ldap_aliases.conf");
            # TODO merge the file with the previous one, for common part (ldap, etc)
            '/etc/postfix/group_aliases.conf': content => template("postfix/group_aliases.conf");
            # TODO make it conditional to the presence of sympa
            '/etc/postfix/sympa_aliases': content => template("postfix/sympa_aliases");
            '/etc/postfix/virtual_aliases': content => template("postfix/virtual_aliases");
        }

        exec { "postmap /etc/postfix/virtual_aliases":
            refreshonly => true,
            subscribe => File['/etc/postfix/virtual_aliases'],
        }
    }

    class secondary_smtp inherits smtp_server {
    }
}
