class sympa {
    class variable {
        $vhost = "ml.$domain"
    }

    class server inherits variable {
        # perl-CGI-Fast is needed for fast cgi
        # perl-Socket6 is required by perl-IO-Socket-SSL
        #  (optional requirement)
        $package_list = ['sympa', 'sympa-www', 'perl-CGI-Fast',
                         'perl-Socket6']
    
        package { $package_list:
            ensure => installed;
        }
    
        # sympa script start 5 differents script, I am not
        # sure that puppet will correctly handle this
        service { "sympa":
            ensure => running,
            hasstatus => true,
            subscribe => [ Package["sympa"], File['/etc/sympa/sympa.conf']]
        }
    
        $password = extlookup("sympa_password",'x')
        $ldap_passwd = extlookup("sympa_ldap",'x')
    
        @@postgresql::user { 'sympa':
            password => $password,
        }
    
        file { '/etc/sympa/sympa.conf':
            ensure => present,
    	# should be cleaner to have it root owned, but puppet do not support acl
    	# and in any case, config will be reset if it change
            owner => sympa,
            group => apache,
            mode => 640,
            content => template("sympa/sympa.conf")
        }
    
        file { '/etc/sympa/auth.conf':
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            content => template("sympa/auth.conf"),
            notify => Service['httpd']
        }
    
    
        include apache::mod_fcgid
        apache::webapp_other{"sympa":
             webapp_file => "sympa/webapp_sympa.conf",
        }
   
        apache::vhost_redirect_ssl { "$vhost": }
 
        apache::vhost_other_app { "$vhost":
            vhost_file => "sympa/vhost_ml.conf",
        }

        openssl::self_signed_cert{ "$vhost":
            directory => "/etc/ssl/apache/"
        }
    

        @@postgresql::database { 'sympa':
            description => "Sympa database",
            user => "sympa",
            require => Postgresql::User["sympa"]
        }
    
        subversion::snapshot { "/etc/sympa/web_tt2":
            source => "svn://svn.mageia.org/svn/web/templates/sympa/trunk"
        }

        file { ["/etc/sympa/lists_xml/",
                "/etc/sympa/data_sources/",
                "/etc/sympa/search_filters/"]:
            ensure => directory,
            owner => root,
            group => root,
            mode => 755,
        }

        define ldap_search_filter {
            file { "/etc/sympa/search_filters/ldap-$name.ldap":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template('sympa/group.ldap') 
            }
        }

        define ldap_group_datasource {
            file { "/etc/sympa/data_sources/ldap-$name.incl":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template('sympa/ldap_group.incl') 
            }
        }
        # add each group that could be used in a sympa ml either as 
        # - owner
        # - editor ( moderation )
        ldap_group_datasource { "mga-sysadm": }
        ldap_group_datasource { "mga-ml_moderators": }

        ldap_search_filter { "mga-board": }

        # directory that will hold the list data
        # i am not sure of the name ( misc, 09/12/10 )
        file { "/var/lib/sympa/expl/":
            ensure => directory,
            owner => sympa,
            group => root,
            mode => 755,
        }
    }

    define list($subject, $profile, $language = 'en') {

        include sympa::variable

        $xml_file = "/etc/sympa/lists_xml/$name.xml"

        file { "$xml_file":
            owner => root,
            group => root,
            content => template('sympa/list.xml')    
        }

        exec { "sympa.pl --create_list --robot=$sympa::variable::vhost --input_file=$xml_file":
            refreshonly => true,
            subscribe => File["$xml_file"]
        }
    }
}

