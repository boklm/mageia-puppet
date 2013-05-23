class mga_buildsystem::config {
    class { 'buildsystem::var::signbot':
	keyid => '80420F66',
    }

    class { 'buildsystem::var::groups':
	packagers => 'mga-packagers',
	packagers_committers => 'mga-packagers-committers',
    }

    include buildsystem::var::scheduler
    include buildsystem::var::repository
    class { 'buildsystem::var::youri':
        packages_archivedir => "${buildsystem::var::scheduler::homedir}/old",
    }

    class { 'buildsystem::var::binrepo':
	uploadmail_from => "root@${::domain}",
	uploadmail_to => "packages-commits@ml.${::domain}",
    }

    $std_repos = ['release','updates_testing','backports_testing','backports','updates']
    $std_medias = {
	'core'    => $std_repos,
	'nonfree' => $std_repos,
	'tainted' => $std_repos,
    }
    $infra_medias = {
	'infra' => ['release'],
    }
    class { 'buildsystem::var::distros':
	distros => {
	    'cauldron' => {
		'medias' => $std_medias,
	    },

	    '1'        => {
		'medias' => $std_medias,
	    },

	    '2'        => {
		'medias' => $std_medias,
	    },

	    'infra_1'  => {
		'medias' => $infra_medias,
	    },

	    'infra_2'  => {
		'medias' => $infra_medias,
	    },
	}
    }

}
