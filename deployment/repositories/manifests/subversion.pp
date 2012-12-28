class repositories::subversion {

    subversion::repository { '/svn/adm/':
        group        => 'mga-sysadmin',
        commit_mail  => ["sysadmin-commits@ml.$::domain"],
        syntax_check => ['check_puppet_templates','check_puppet'],
    }

    sudo::sudoers_config { 'puppet_update':
        content => template('repositories/puppet_update.sudoers')
    }

    subversion::hook::post_commit { '/svn/adm/|puppet_update':
        content => template('repositories/puppet_update.sh')
    }

    subversion::repository { '/svn/org/':
        group        => 'mga-board',
        commit_mail  => ["board-commits@ml.$::domain"],
    }

    subversion::repository { '/svn/soft/':
        group        => 'mga-packagers',
        commit_mail  => ["soft-commits@ml.$::domain"],
        syntax_check => ['check_po'],
        i18n_mail    => ["mageia-i18n@$::domain"],
    }

    subversion::repository { '/svn/soft_publish/':
        group       => 'mga-packagers',
        commit_mail => ["soft-commits@ml.$::domain"],
    }

    subversion::repository { '/svn/web/':
        group        => 'mga-web',
        syntax_check => ['check_php'],
    }

    subversion::repository { '/svn/packages/':
        group       => 'mga-packagers-committers',
        no_binary   => true,
	commit_mail => ["packages-commits@ml.$::domain"],
    }
}
