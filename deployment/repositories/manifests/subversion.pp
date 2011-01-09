class repositories::subversion {

    subversion::repository { "/svn/adm/":
        group => "mga-sysadmin",
        commit_mail => ['mageia-sysadm@mageia.org', "sysadmin-commits@ml.$domain"],
        syntax_check1 => 'check_puppet_templates',
        syntax_check2 => 'check_puppet',
        cia_post => true,
        cia_module => "sysadm",
    }

    subversion::repository { "/svn/soft/":
	    group => "mga-packagers",
	    commit_mail => ['mageia-sysadm@mageia.org'],
	    cia_post => true,
	    cia_module => "soft",
    }

    subversion::repository { "/svn/web/":
	    group => "mga-committers",
        cia_post => true,
        cia_module => "web",
    }

    subversion::repository { "/svn/packages/":
        group => "mga-packagers",
        no_binary => true,
        cia_post => true,
        cia_module => "packages",
        cia_ignore_author => '^schedbot$',
    }

    file { "/svn/binrepos/":
        ensure => directory
    }

    subversion::repository { "/svn/binrepos/cauldron/":
        group => "mga-packagers",
        cia_post => true,
        cia_module => "binrepos",
        cia_ignore_author => '^schedbot$',
    }

}
