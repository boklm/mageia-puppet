class sympa {
    class variable {
        $vhost = "ml.$::domain"
    }

    class server inherits variable {
        # perl-CGI-Fast is needed for fast cgi
        # perl-Socket6 is required by perl-IO-Socket-SSL
        #  (optional requirement)
        package {['sympa',
                  'sympa-www',
                  'perl-CGI-Fast',
                  'perl-Socket6']: }

        # sympa script start 5 differents script, I am not
        # sure that puppet will correctly handle this
        service { 'sympa':
            subscribe => [ Package['sympa'], File['/etc/sympa/sympa.conf']]
        }

        $pgsql_password = extlookup('sympa_pgsql','x')
        $ldap_password = extlookup('sympa_ldap','x')

        postgresql::remote_db_and_user { 'sympa':
            password    => $pgsql_password,
            description => 'Sympa database',
        }

        File {
            require => Package['sympa'],
        }

        file { '/etc/sympa/sympa.conf':
        # should be cleaner to have it root owned, but puppet do not support acl
        # and in any case, config will be reset if it change
            owner   => 'sympa',
            group   => 'apache',
            mode    => '0640',
            content => template('sympa/sympa.conf'),
        }

        file { '/etc/sympa/auth.conf':
            content => template('sympa/auth.conf'),
            notify  => Service['httpd'],
        }


        include apache::mod::fcgid
        apache::webapp_other { 'sympa':
            webapp_file => 'sympa/webapp_sympa.conf',
        }

        apache::vhost_redirect_ssl { $sympa::variable::vhost: }

        apache::vhost_base { $sympa::variable::vhost:
            use_ssl => true,
            content => template('sympa/vhost_ml.conf'),
        }

        subversion::snapshot { '/etc/sympa/web_tt2':
            source => 'svn://svn.mageia.org/svn/web/templates/sympa/trunk',
        }

        file { ['/etc/sympa/lists_xml/',
                '/etc/sympa/scenari/',
                '/etc/sympa/data_sources/',
                '/etc/sympa/search_filters/']:
            ensure  => directory,
            purge   => true,
            recurse => true,
            force   => true,
        }

        file {
            '/etc/sympa/scenari/subscribe.open_web_only_notify':
                source => 'puppet:///modules/sympa/scenari/open_web_only_notify';
            '/etc/sympa/scenari/unsubscribe.open_web_only_notify':
                source => 'puppet:///modules/sympa/scenari/open_web_only_notify';
            '/etc/sympa/scenari/send.subscriber_moderated':
                source => 'puppet:///modules/sympa/scenari/subscriber_moderated';
            '/etc/sympa/scenari/create_list.forbidden':
                source => 'puppet:///modules/sympa/scenari/forbidden';
            '/etc/sympa/topics.conf':
                source => 'puppet:///modules/sympa/topics.conf';
        }

        # add each group that could be used in a sympa ml either as
        # - owner
        # - editor ( moderation )
        sympa::datasource::ldap_group { 'mga-sysadmin': }
        sympa::datasource::ldap_group { 'mga-ml_moderators': }


        # directory that will hold the list data
        # i am not sure of the name ( misc, 09/12/10 )
        file { '/var/lib/sympa/expl/':
            ensure => directory,
            owner  => 'sympa',
        }
    }
}
