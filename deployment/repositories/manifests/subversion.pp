class repositories::subversion {

    Subversion::Repository {
        cia_post => true,
        cia_ignore_author => '^schedbot$',
    }

    subversion::repository { "/svn/adm/":
        group => "mga-sysadmin",
        commit_mail => ["sysadmin-commits@ml.$domain"],
        syntax_check => ['check_puppet_templates','check_puppet'],
        cia_module => "sysadm",
    }

    sudo::sudoers_config { "puppet_update":
        content => template("repositories/puppet_update.sudoers")
    }

    subversion::hook::post_commit { "/svn/adm/|puppet_update":
        content => template("repositories/puppet_update.sh")
    }

    subversion::repository { "/svn/soft/":
	    group => "mga-packagers",
	    commit_mail => ["soft-commits@ml.$domain"],
        syntax_check => ['check_po'],
	    cia_module => "soft",
        i18n_mail => ["mageia-i18n@$domain"],
    }

    subversion::repository { "/svn/soft_publish/":
	group => "mga-packagers",
	commit_mail => ["soft-commits@ml.$domain"],
	cia_post => true,
	cia_module => "soft_publish",
    }

    subversion::repository { "/svn/web/":
	    group => "mga-web",
        syntax_check => ['check_php'],
        cia_module => "web",
    }

    subversion::repository { "/svn/packages/":
        group => "mga-packagers-committers",
        no_binary => true,
	    commit_mail => ["packages-commits@ml.$domain"],
        cia_module => "packages",
#	restricted_to_user => 'schedbot',
    }

    file { "/svn/binrepos/":
        ensure => directory,
	mode => 700,
    }

    subversion::repository { "/svn/binrepos/cauldron/":
        group => "mga-packagers-committers",
        cia_module => "binrepos",
#	restricted_to_user => 'schedbot',
    }

    file { "/svn/binrepos/updates/":
        ensure => directory
    }

    subversion::repository { "/svn/binrepos/updates/1/":
        group => "mga-packagers-committers",
        cia_module => "binrepos_1",
#	restricted_to_user => 'schedbot',
    }
}
