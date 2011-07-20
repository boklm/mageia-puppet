class repositories::subversion {

    subversion::repository { "/svn/adm/":
        group => "mga-sysadmin",
        commit_mail => ["sysadmin-commits@ml.$domain"],
        syntax_check => ['check_puppet_templates','check_puppet'],
        cia_post => true,
        cia_module => "sysadm",
    }

    subversion::repository { "/svn/soft/":
	    group => "mga-packagers",
	    commit_mail => ["soft-commits@ml.$domain"],
        syntax_check => ['check_po'],
	    cia_post => true,
	    cia_module => "soft",
        i18n_mail => ["mageia-i18n@$domain"],
    }

    subversion::repository { "/svn/web/":
	    group => "mga-web",
        syntax_check => ['check_php'],
        cia_post => true,
        cia_module => "web",
    }

    subversion::repository { "/svn/packages/":
        group => "mga-packagers-committers",
        no_binary => true,
	    commit_mail => ["packages-commits@ml.$domain"],
        cia_post => true,
        cia_module => "packages",
        cia_ignore_author => '^schedbot$',
#	restricted_to_user => 'schedbot',
    }

    file { "/svn/binrepos/":
        ensure => directory
    }

    subversion::repository { "/svn/binrepos/cauldron/":
        group => "mga-packagers-committers",
        cia_post => true,
        cia_module => "binrepos",
        cia_ignore_author => '^schedbot$',
#	restricted_to_user => 'schedbot',
    }

    file { "/svn/binrepos/updates/":
        ensure => directory
    }

    subversion::repository { "/svn/binrepos/updates/1/":
        group => "mga-packagers-committers",
        cia_post => true,
        cia_module => "binrepos_1",
        cia_ignore_author => '^schedbot$',
#	restricted_to_user => 'schedbot',
    }
}
