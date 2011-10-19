class wikis {
    class { "mediawiki::config":
	pgsql_password => extlookup("mediawiki_pgsql",'x'),
	secretkey => extlookup("mediawiki_secretkey",'x'),
	ldap_password => extlookup('mediawiki_ldap','x'),
    }

    mediawiki::instance { "en": 
        title => "Mageia wiki",
    }
}
