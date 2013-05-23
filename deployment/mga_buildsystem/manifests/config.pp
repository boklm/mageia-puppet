class mga_buildsystem::config {
    class { 'buildsystem::var::signbot':
	keyid => '80420F66',
    }

    class { 'buildsystem::var::groups':
	packagers => 'mga-packagers',
	packagers_committers => 'mga-packagers-committers',
    }

    class { 'buildsystem::var::scheduler' :
	admin_mail => 'mageia-sysadm@mageia.org',
    }
    include buildsystem::var::repository
    class { 'buildsystem::var::youri':
        packages_archivedir => "${buildsystem::var::scheduler::homedir}/old",
    }

    class { 'buildsystem::var::binrepo':
	uploadmail_from => "root@${::domain}",
	uploadmail_to => "packages-commits@ml.${::domain}",
    }

    $svn_hostname = "svn.$::domain"
    $svn_root_packages = "svn://${svn_hostname}/svn/packages"
    class { 'buildsystem::var::mgarepo':
	submit_host => "pkgsubmit.${::domain}",
	svn_hostname => $svn_hostname,
	svn_root_packages => $svn_root_packages,
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
	    'requires' => [],
	},
	'updates_testing' => {
	    'media_types' => [ 'testing' ],
	    'noauto' => '1',
	    'requires' => [ 'updates' ],
	},
	'backports_testing' => {
	    'media_types' => [ 'testing' ],
	    'noauto' => '1',
	    'requires' => [ 'backports' ],
	},
	'backports' => {
	    'media_types' => [ 'backports' ],
	    'noauto' => '1',
	    'requires' => [ 'updates' ],
	},
	'updates' => {
	    'media_types' => [ 'updates' ],
	    'updates_for' => 'release',
	    'requires' => [ 'release' ],
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
	    'requires' => [ 'core' ],
	},
	'tainted' => {
	    'repos' => $std_repos,
	    'media_types' => [ 'official' ],
	    'noauto' => '1',
	    'requires' => [ 'core' ],
	},
    }
    $std_base_media = [ 'core/release', 'core/updates' ]
    $infra_medias = {
	'infra' => {
	    'repos' => {
		'updates' => {
		    'media_types' => [ 'updates' ],
		    'requires' => [ 'release' ],
		},
	    },
	    'media_types' => [ 'infra' ],
	    'requires' => [ 'core' ],
	},
    }
    $std_macros = {
	'distsuffix' => '.mga',
	'distribution' => 'Mageia',
	'vendor' => 'Mageia.Org',
	'_real_vendor' => 'mageia',
    }
    $repo_allow_from = [
	'2a02:2178:2:7::3/64', # valstar
	'2a02:2178:2:7::4/64', # ecosse
	'2a02:2178:2:7::5/64', # jonund
	".${::domain}",
	'10.42.0',
	'212.85.158.152',      #rabbit
    ]
    class { 'buildsystem::var::distros':
	default_distro => 'cauldron',
	distros => {
	    'cauldron' => {
		'arch' => $std_arch,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
		'branch' => 'Devel',
		'version' => '3',
		'submit_allowed' => "${svn_root_packages}/cauldron",
		'macros' => $std_macros,
		'repo_allow_from' => $repo_allow_from,
	    },

	    '1'        => {
		'arch' => $std_arch,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
		'branch' => 'Official',
		'version' => '1',
		'submit_allowed' => "${svn_root_packages}/updates/1",
		'macros' => $std_macros,
		'repo_allow_from' => $repo_allow_from,
	    },

	    '2'        => {
		'arch' => $std_arch,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
		'branch' => 'Official',
		'version' => '2',
		'submit_allowed' => "${svn_root_packages}/updates/2",
		'macros' => $std_macros,
		'repo_allow_from' => $repo_allow_from,
	    },

	    'infra_1'  => {
		'arch' => $std_arch,
		'medias' => $infra_medias,
		'base_media' => $std_base_media,
		'branch' => 'Official',
		'version' => '1',
		'submit_allowed' => $svn_root_packages,
		'macros' => $std_macros,
		'based_on' => {
		    '1' => {
			'core' => [ 'release', 'updates' ],
		    },
		},
	    },

	    'infra_2'  => {
		'arch' => $std_arch,
		'medias' => $infra_medias,
		'base_media' => $std_base_media,
		'branch' => 'Official',
		'version' => '2',
		'submit_allowed' => $svn_root_packages,
		'macros' => $std_macros,
		'based_on' => {
		    '2' => {
			'core' => [ 'release', 'updates' ],
		    },
		},
	    },
	}
    }

}
