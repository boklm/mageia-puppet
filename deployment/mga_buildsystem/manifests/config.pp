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

    class { 'buildsystem::var::mgarepo':
	submit_host => "pkgsubmit.${::domain}",
	svn_hostname => "svn.$::domain",
	svn_root_packages => "svn://svn.${::domain}/svn/packages",
	oldurl => "svn+ssh://svn.${::domain}/svn/packages/misc",
	conf => {
	    'global' => {
		'ldap-server' => "ldap.${::domain}",
		'ldap-base' => "ou=People,${::dc_suffix}",
		'ldap-filterformat' => '(&(objectClass=inetOrgPerson)(uid=$username))',
		'ldap-resultformat' => '$cn <$mail>',
	    }
	}
    }

    $std_arch = ['i586', 'x86_64']
    $std_repos = {
	'release' => {
	    'media_types' => [ 'release' ],
	},
	'updates_testing' => {
	    'media_types' => [ 'testing' ],
	    'noauto' => '1',
	},
	'backports_testing' => {
	    'media_types' => [ 'testing' ],
	    'noauto' => '1',
	},
	'backports' => {
	    'media_types' => [ 'backports' ],
	    'noauto' => '1',
	},
	'updates' => {
	    'media_types' => [ 'updates' ],
	    'updates_for' => 'release',
	},
    }
    $std_medias = {
	'core'    => {
	    'repos' => $std_repos,
	    'media_types' => [ 'official', 'free' ],
	},
	'nonfree' => {
	    'repos' => $std_repos,
	    'media_types' => [ 'official' ],
	    'noauto' => '1',
	},
	'tainted' => {
	    'repos' => $std_repos,
	    'media_types' => [ 'official' ],
	    'noauto' => '1',
	},
    }
    $std_base_media = [ 'core/release', 'core/updates' ]
    $infra_medias = {
	'infra' => {
	    'repos' => {
		'release' => {
		    'media_types' => [ 'release' ],
		},
	    },
	    'media_types' => [ 'infra' ],
	},
    }
    class { 'buildsystem::var::distros':
	default_distro => 'cauldron',
	distros => {
	    'cauldron' => {
		'arch' => $std_arch,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
		'branch' => 'Devel',
		'version' => '3',
	    },

	    '1'        => {
		'arch' => $std_arch,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
		'branch' => 'Official',
		'version' => '1',
	    },

	    '2'        => {
		'arch' => $std_arch,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
		'branch' => 'Official',
		'version' => '2',
	    },

	    'infra_1'  => {
		'arch' => $std_arch,
		'medias' => $infra_medias,
		'base_media' => $std_base_media,
		'branch' => 'Official',
		'version' => '1',
	    },

	    'infra_2'  => {
		'arch' => $std_arch,
		'medias' => $infra_medias,
		'base_media' => $std_base_media,
		'branch' => 'Official',
		'version' => '2',
	    },
	}
    }

}
