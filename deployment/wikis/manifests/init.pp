class wikis {
    $wikis_root = '/srv/wiki'
    $wikis_templates = '/srv/wiki-templates'
    class { "mediawiki::config":
	pgsql_password => extlookup("mediawiki_pgsql",'x'),
	secretkey => extlookup("mediawiki_secretkey",'x'),
	ldap_password => extlookup('mediawiki_ldap','x'),
	root => $wikis_root,
	vhost => false,
    }

    subversion::snapshot { $wikis_templates:
	source => "svn://svn.$domain/svn/web/templates/mediawiki"
    }

    $wiki_languages = [ 'en', 'fr' ]
    mediawiki::instance { "en": 
        title => "Mageia wiki",
	wiki_settings => template('wikis/wiki_settings'),
    }

    apache::vhost_redirect_ssl { "wiki.$domain": }

    apache::vhost_base { "ssl_wiki.$domain":
	location => '/dev/null',
	use_ssl => true,
	vhost => "wiki.$domain",
	content => template("wikis/wiki_vhost.conf"),
    }
}
