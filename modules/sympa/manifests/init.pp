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
    
        $pgsql_password = extlookup("sympa_pgsql",'x')
        $ldap_password = extlookup("sympa_ldap",'x')
    
        postgresql::remote_db_and_user { 'sympa':
            password => $pgsql_password,
            description => "Sympa database",
        }
  
        file { '/etc/sympa/sympa.conf':
            ensure => present,
    	# should be cleaner to have it root owned, but puppet do not support acl
    	# and in any case, config will be reset if it change
            owner => sympa,
            group => apache,
            mode => 640,
            content => template("sympa/sympa.conf"),
            require => Package[sympa],
        }
    
        file { '/etc/sympa/auth.conf':
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            content => template("sympa/auth.conf"),
            require => Package[sympa],
            notify => Service['httpd'],
        }
    
    
        include apache::mod_fcgid
        apache::webapp_other{"sympa":
             webapp_file => "sympa/webapp_sympa.conf",
        }
   
        apache::vhost_redirect_ssl { "$vhost": }
 
        apache::vhost_base { "$vhost":
	    use_ssl => true,
            content => template("sympa/vhost_ml.conf"),
        }
   
        subversion::snapshot { "/etc/sympa/web_tt2":
            source => "svn://svn.mageia.org/svn/web/templates/sympa/trunk"
        }

        file { ["/etc/sympa/lists_xml/",
                "/etc/sympa/scenari/",
                "/etc/sympa/data_sources/",
                "/etc/sympa/search_filters/"]:
            ensure => directory,
            owner => root,
            group => root,
            mode => 755,
            purge => true,
            recurse => true,
            force => true,
            require => Package[sympa],
        }

        file { ["/etc/sympa/scenari/subscribe.open_web_only_notify",
                "/etc/sympa/scenari/unsubscribe.open_web_only_notify"]:
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            source => "puppet:///modules/sympa/scenari/open_web_only_notify",
        }

        file { ["/etc/sympa/scenari/send.subscriber_moderated"]:
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            source => "puppet:///modules/sympa/scenari/subscriber_moderated",
        }

        file { ["/etc/sympa/scenari/create_list.forbidden"]:
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            source => "puppet:///modules/sympa/scenari/forbidden",
        }


        file { ["/etc/sympa/topics.conf"]:
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            source => "puppet:///modules/sympa/topics.conf",
            require => Package[sympa],
        }

        define ldap_search_filter {
            file { "/etc/sympa/search_filters/$name.ldap":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template('sympa/search_filters/group.ldap') 
            }
        }

        define ldap_group_datasource {
            file { "/etc/sympa/data_sources/$name.incl":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template('sympa/data_sources/ldap_group.incl') 
            }
        }

        define scenario_sender_ldap_group {
            file { "/etc/sympa/scenari/send.restricted_$name":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template('sympa/scenari/sender.ldap_group') 
            }
        }

        define scenario_sender_email {
            $sender_email_file = regsubst($name,'\@','-at-')
            file { "/etc/sympa/scenari/send.restricted_$sender_email_file":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template('sympa/scenari/sender.email') 
            }
        }

        # add each group that could be used in a sympa ml either as 
        # - owner
        # - editor ( moderation )
        ldap_group_datasource { "mga-sysadmin": }
        ldap_group_datasource { "mga-ml_moderators": }


        # directory that will hold the list data
        # i am not sure of the name ( misc, 09/12/10 )
        file { "/var/lib/sympa/expl/":
            ensure => directory,
            owner => sympa,
            group => root,
            mode => 755,
            require => Package[sympa],
        }
    }

    define list($subject, 
                $profile = false, 
                $language = 'en',
                $topics = false,
                $reply_to = false,
                $sender_email = false,
                $sender_ldap_group = false,
                $subscriber_ldap_group = false,
                $public_archive = true,
                $subscription_open = false,
    		$custom_subject = '') {

        include sympa::variable
        $ldap_password = extlookup("sympa_ldap",'x')

        $xml_file = "/etc/sympa/lists_xml/$name.xml"

        if $sender_email {
            $sender_email_file = regsubst($sender_email,'\@','-at-')
        } else { 
            $sender_email_file = '' 
        }

        file { "$xml_file":
            owner => root,
            group => root,
            content => template('sympa/list.xml'),
            require => Package[sympa],
        }

        exec { "sympa.pl --create_list --robot=$sympa::variable::vhost --input_file=$xml_file":
            require => File["$xml_file"],
            creates => "/var/lib/sympa/expl/$name",
            before => File["/var/lib/sympa/expl/$name/config"],
        }

        file { "/var/lib/sympa/expl/$name/config":
            ensure => present,
            owner => sympa,
            group => sympa,
            mode => 750,
            content => template("sympa/config"), 
            notify => Service['sympa'],
        }

        if $sender_ldap_group {
            if ! defined(Sympa::Server::Scenario_sender_ldap_group[$sender_ldap_group]) {
                sympa::server::scenario_sender_ldap_group { $sender_ldap_group: }
            }
        }

        if $sender_email {
            if ! defined(Sympa::Server::Scenario_sender_email[$sender_email]) {
                sympa::server::scenario_sender_email { $sender_email: }
            }
        }
        
        if $subscriber_ldap_group {
            if ! defined(Sympa::Server::Ldap_search_filter[$subscriber_ldap_group]) {
                sympa::server::ldap_search_filter { $subscriber_ldap_group: }
            }
        }
    }

#
#   various types of list that can be directly used
#
#
    define public_list($subject, $language = 'en', $topics = false) {
        list { $name:
            subject => $subject,
           # profile => "public",
            language => $language,
            topics => $topics,
        }
    }

    # list where announce are sent by member of ldap_group
    # reply_to is set to $reply_to
    define announce_list_group($subject, $reply_to, $sender_ldap_group, $language = 'en', $topics = false) {
        # profile + scenario
        list{ $name:
            subject => $subject,
            profile => "",
            language => $language,
            topics => $topics,
            reply_to => $reply_to,
            sender_ldap_group => $sender_ldap_group,
        }
    }


    # list where announce are sent by $email only 
    # reply_to is set to $reply_to    
    define announce_list_email($subject, $reply_to, $sender_email, $language = 'en', $topics = false) {
       list{ $name:
            subject => $subject,
            profile => "",
            language => $language,
            topics => $topics,
            reply_to => $reply_to,
            sender_email => $sender_email,
        }
    }

    # list where people cannot subscribe, where people from $ldap_group receive
    # mail, with public archive
    define restricted_list($subject, $subscriber_ldap_group, $language = 'en', $topics = false) {
       list{ $name:
            subject => $subject,
            profile => "",
            topics => $topics,
            language => $language,
            subscriber_ldap_group => $subscriber_ldap_group,
            sender_ldap_group => $subscriber_ldap_group,
        }
    }

    # list where only people from the ldap_group can post, ad where they are subscribe
    # by default, but anybody else can subscribe to read and receive messages
    define public_restricted_list($subject, $subscriber_ldap_group, $language = 'en', $topics = false) {
       list{ $name:
            subject => $subject,
            profile => "",
            topics => $topics,
            language => $language,
            subscriber_ldap_group => $subscriber_ldap_group,
            sender_ldap_group => $subscriber_ldap_group,
            subscription_open => true,
        }
    }


    # same as restricted list, but anybody can post
    define restricted_list_open($subject, $subscriber_ldap_group, $language = 'en', $topics = false) {
       list{ $name:
            subject => $subject,
            profile => "",
            language => $language,
            topics => $topics,
            subscriber_ldap_group => $subscriber_ldap_group,
            sender_ldap_group => $subscriber_ldap_group,
        }        
    }

    # list with private archive, restricted to member of $ldap_group
    define private_list($subject, $subscriber_ldap_group, $language ='en', $topics = false) {
       list{ $name:
            subject => $subject,
            profile => "",
            language => $language,
            topics => $topics,
            subscriber_ldap_group => $subscriber_ldap_group,
            sender_ldap_group => $subscriber_ldap_group,
            public_archive => false,
        }
    }
    
    # list with private archive, restricted to member of $ldap_group
    # everybody can post 
    # used for contact alias
    define private_list_open($subject, $subscriber_ldap_group, $language ='en', $topics = false) {
       list{ $name:
            subject => $subject,
            profile => "",
            language => $language,
            topics => $topics,
            subscriber_ldap_group => $subscriber_ldap_group,
            public_archive => false,
        }
    }

    # same as private_list, but post are restricted to $email
    # ( scripting )
    define private_list_email($subject, $subscriber_ldap_group, $sender_email, $language ='en', $topics = false) {
        list{ $name:
            subject => $subject,
            profile => "",
            language => $language,
            topics => $topics,
            subscriber_ldap_group => $subscriber_ldap_group,
            sender_email => $sender_email,
            public_archive => false,
        }
    }
}

