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

    $std_arch = ['i586', 'x86_64']
    $std_repos = ['release','updates_testing','backports_testing','backports','updates']
    $std_medias = {
	'core'    => $std_repos,
	'nonfree' => $std_repos,
	'tainted' => $std_repos,
    }
    $std_base_media = [ 'core/release', 'core/updates' ]
    $infra_medias = {
	'infra' => ['release'],
    }
    class { 'buildsystem::var::distros':
	distros => {
	    'cauldron' => {
		'arch' => $std_arch,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
	    },

	    '1'        => {
		'arch' => $std_arch,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
	    },

	    '2'        => {
		'arch' => $std_arch,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
	    },

	    'infra_1'  => {
		'arch' => $std_arch,
		'medias' => $infra_medias,
		'base_media' => $std_base_media,
	    },

	    'infra_2'  => {
		'arch' => $std_arch,
		'medias' => $infra_medias,
		'base_media' => $std_base_media,
	    },
	}
    }

}
