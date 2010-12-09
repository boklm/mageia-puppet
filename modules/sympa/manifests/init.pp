class sympa {
    class server {
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
            subscribe => [ Package["sympa"]]
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
            content => template("sympa/auth.conf")
        }
    
    
        include apache::mod_fcgid
        apache::webapp_other{"sympa":
    	webapp_file => "sympa/webapp_sympa.conf",
        }
    
        apache::vhost_other_app { "ml.$domain":
            vhost_file => "sympa/vhost_ml.conf",
        }
    
        @@postgresql::database { 'sympa':
            description => "Sympa database",
            user => "sympa",
            require => Postgresql::User["sympa"]
        }
    
        subversion::snapshot { "/etc/sympa/web_tt2":
            source => "svn://svn.mageia.org/svn/web/templates/sympa/trunk"
        }

        file { "/etc/sympa/lists_xml/":
            ensure => directory,
            owner => root,
            group => root,
            mode => 755,
        }
    }

    define list($subject, $profile, $language = 'en') {

        $xml_file = "/etc/sympa/lists_xml/$name.xml"

        file { "$xml_file":
            owner => root,
            group => root,
            content => template('sympa/list.xml')    
        }

        exec { "sympa.pl --create_list --robot=ml.$domain --input_file=$xml_file":
            refreshonly => true,
            subscribe => File["$xml_file"]
        }
    }
}

