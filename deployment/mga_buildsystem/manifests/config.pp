class mga_buildsystem::config {
    class { 'buildsystem::var::signbot':
	keyid => '80420F66',
	keyemail => "packages@${::domain}",
	keyname => 'Mageia Packages',
    }

    class { 'buildsystem::var::groups':
	packagers => 'mga-packagers',
	packagers_committers => 'mga-packagers-committers',
    }

    class { 'buildsystem::var::webstatus' :
	package_commit_url => 'http://svnweb.mageia.org/packages?view=revision&revision=%d',
	theme_name => 'mageia',
    }

    class { 'buildsystem::var::scheduler' :
	admin_mail => 'mageia-sysadm@mageia.org',
	build_nodes => {
	    'i586' => [ 'jonund0', 'ecosse0', 'jonund1', 'ecosse1' ],
	    'x86_64' => [ 'ecosse0', 'jonund0', 'ecosse1', 'jonund1' ],
	},
	build_nodes_aliases => {
	    'jonund0' => "jonund.${::domain}",
	    'jonund1' => "jonund.${::domain}",
	    'ecosse0' => "ecosse.${::domain}",
	    'ecosse1' => "ecosse.${::domain}",
	},
	build_src_node => "valstar",
    }
    include buildsystem::var::repository
    class { 'buildsystem::var::binrepo':
	uploadmail_from => "root@${::domain}",
	uploadmail_to => "packages-commits@ml.${::domain}",
    }

    $svn_hostname = "svn.$::domain"
    $svn_root_packages = "svn://${svn_hostname}/svn/packages"
    $svn_root_packages_ssh = "svn+ssh://${svn_hostname}/svn/packages"
    class { 'buildsystem::var::mgarepo':
	submit_host => "pkgsubmit.${::domain}",
	svn_hostname => $svn_hostname,
	svn_root_packages => $svn_root_packages,
	svn_root_packages_ssh => $svn_root_packages_ssh,
	oldurl => "${svn_root_packages_ssh}/misc",
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
	    'media_type' => [ 'release' ],
	    'requires' => [],
            'order' => 0,
	},
	'updates' => {
	    'media_type' => [ 'updates' ],
	    'updates_for' => 'release',
	    'requires' => [ 'release' ],
            'order' => 1,
	},
	'updates_testing' => {
	    'media_type' => [ 'testing' ],
	    'noauto' => '1',
	    'requires' => [ 'updates' ],
            'order' => 2,
	},
	'backports' => {
	    'media_type' => [ 'backports' ],
	    'noauto' => '1',
	    'requires' => [ 'updates' ],
            'order' => 3,
	},
	'backports_testing' => {
	    'media_type' => [ 'testing' ],
	    'noauto' => '1',
	    'requires' => [ 'backports' ],
            'order' => 4,
	},
    }
    $std_medias = {
	'core'    => {
	    'repos' => $std_repos,
	    'media_type' => [ 'official', 'free' ],
            'order' => 0,
	},
	'nonfree' => {
	    'repos' => $std_repos,
	    'media_type' => [ 'official' ],
	    'noauto' => '1',
	    'requires' => [ 'core' ],
            'order' => 1,
	},
	'tainted' => {
	    'repos' => $std_repos,
	    'media_type' => [ 'official' ],
	    'noauto' => '1',
	    'requires' => [ 'core' ],
            'order' => 2,
	},
    }
    $std_base_media = [ 'core/release', 'core/updates' ]
    $infra_medias = {
	'infra' => {
	    'repos' => {
		'updates' => {
		    'media_type' => [ 'updates' ],
		    'requires' => [ 'release' ],
                    'order' => 0,
		},
	    },
	    'media_type' => [ 'infra' ],
	    'requires' => [ 'core' ],
            'order' => 0,
	},
    }
    $std_macros = {
	'distsuffix' => '.mga',
	'distribution' => 'Mageia',
	'vendor' => 'Mageia.Org',
	'_real_vendor' => 'mageia',
    }
    $repo_allow_from = [
	$::nodes_ipaddr[valstar][ipv6],
	$::nodes_ipaddr[valstar][ipv4],
	$::nodes_ipaddr[ecosse][ipv6],
	$::nodes_ipaddr[ecosse][ipv4],
	$::nodes_ipaddr[jonund][ipv6],
	$::nodes_ipaddr[jonund][ipv4],
	".${::domain}",
	'10.42.0',
	$::nodes_ipaddr[rabbit][ipv4],
	$::nodes_ipaddr[rabbit][ipv6],
    ]

    # the list of checks, actions, posts for cauldron in youri-upload
    $cauldron_youri_upload_targets = {
	'checks' => [
	    'version',
	    'tag',
	    'acl',
	    'rpmlint',
	    'recency',
	],
	'actions' => [
	    'markrelease',
	    'sign',
	    'install',
	    'link',
	    'unpack_release_notes',
	    'unpack_gfxboot_theme',
	    'unpack_meta_task',
	    'unpack_installer_images',
	    'unpack_installer_images_nonfree',
	    'unpack_installer_stage2',
	    'unpack_installer_advertising',
	    'unpack_installer_rescue',
	    'unpack_syslinux',
	    'archive',
	    'mail',
	    'maintdb',
	],
	'posts' => [
	    'genhdlist2',
	    'clean_rpmsrate',
	    'mirror',
	],
    }

    # the list of checks, actions, posts for stable distros in youri-upload
    $std_youri_upload_targets = {
	'checks' => [
	    'version',
	    'tag',
	    'acl',
	    'rpmlint',
	    'recency',
	],
	'actions' => [
	    'sign',
	    'install',
	    'link',
	    'archive',
	    'mail',
	],
	'posts' => [
	    'genhdlist2',
	    'clean_rpmsrate',
	    'mirror',
	],
    }

    # the list of checks, actions, posts for infra distros in youri-upload
    $infra_youri_upload_targets = {
	'checks' => [
	    'version',
	    'tag',
	    'acl',
	    'rpmlint',
	    'recency',
	],
	'actions' => [
	    'sign',
	    'install',
	    'link',
	    'archive',
	],
	'posts' => [
	    'genhdlist2',
	],
    }

    # the list of checks, actions, posts for cauldron in youri-todo
    $cauldron_youri_todo_targets = {
	'checks' => [
	    'source',
	    'deps',
	    'version',
	    'tag',
	    'acl',
	    'host',
	    'rpmlint',
	    'recency',
	    'queue_recency',
	],
	'actions' => [
	    'send',
	    'rpminfo',
	],
    }

    # the list of checks, actions, posts for stable distros in youri-todo
    $std_youri_todo_targets = {
	'checks' => [
	    'source',
	    'version',
	    'tag',
	    'acl',
	    'host',
	    'rpmlint',
	    'recency',
	    'queue_recency',
	],
	'actions' => [
	    'send',
	    'rpminfo',
	    'ulri',
	],
    }

    # the list of checks, actions, posts for infra distros in youri-todo
    $infra_youri_todo_targets = {
	'checks' => [
	    'source',
	    'version',
	    'tag',
	    'acl',
	    'rpmlint',
	    'recency',
	    'queue_recency',
	],
	'actions' => [
	    'send',
	    'rpminfo',
	    'ulri',
	],
    }

    # rpmlint check options for mageia <= 2
    $mga2_rpmlint = {
	'config' => '/usr/share/rpmlint/config.mga2',
	'path' => '/usr/bin/mga2-rpmlint',
        'results' => [
            'buildprereq-use',
            'no-description-tag',
            'no-summary-tag',
            'non-standard-group',
            'non-xdg-migrated-menu',
            'percent-in-conflicts',
            'percent-in-dependency',
            'percent-in-obsoletes',
            'percent-in-provides',
            'summary-ended-with-dot',
            'unexpanded-macro',
            'unknown-lsb-keyword',
            'malformed-line-in-lsb-comment-block',
            'empty-%postun',
            'empty-%post',
            'invalid-desktopfile',
            'standard-dir-owned-by-package',
            'use-tmp-in-%postun',
            'bogus-variable-use-in-%posttrans',
            'dir-or-file-in-usr-local',
            'dir-or-file-in-tmp',
            'dir-or-file-in-mnt',
            'dir-or-file-in-opt',
            'dir-or-file-in-home',
            'dir-or-file-in-var-local',
            ],
    }

    # rpmlint check options for Mageia 3
    $mga3_rpmlint = {
	'config' => '/usr/share/rpmlint/config',
	'path' => '/usr/bin/rpmlint',
        'results' => [
            'buildprereq-use',
            'no-description-tag',
            'no-summary-tag',
            'non-standard-group',
            'non-xdg-migrated-menu',
            'percent-in-conflicts',
            'percent-in-dependency',
            'percent-in-obsoletes',
            'percent-in-provides',
            'summary-ended-with-dot',
            'unexpanded-macro',
            'unknown-lsb-keyword',
            'malformed-line-in-lsb-comment-block',
            'empty-%postun',
            'empty-%post',
            'invalid-desktopfile',
            'standard-dir-owned-by-package',
            'use-tmp-in-%postun',
            'bogus-variable-use-in-%posttrans',
            'dir-or-file-in-usr-local',
            'dir-or-file-in-tmp',
            'dir-or-file-in-mnt',
            'dir-or-file-in-opt',
            'dir-or-file-in-home',
            'dir-or-file-in-var-local',
            'tmpfiles-conf-in-etc',
            'non-ghost-in-run',
            'non-ghost-in-var-run',
            'non-ghost-in-var-lock',
            'systemd-unit-in-etc',
            'udev-rule-in-etc',
        ],
    }

    # rpmlint check options for cauldron
    $cauldron_rpmlint = {
	'config' => '/usr/share/rpmlint/config',
	'path' => '/usr/bin/rpmlint',
        'results' => [
            'buildprereq-use',
            'no-description-tag',
            'no-summary-tag',
            'non-standard-group',
            'non-xdg-migrated-menu',
            'percent-in-conflicts',
            'percent-in-dependency',
            'percent-in-obsoletes',
            'percent-in-provides',
            'summary-ended-with-dot',
            'unexpanded-macro',
            'unknown-lsb-keyword',
            'malformed-line-in-lsb-comment-block',
            'empty-%postun',
            'empty-%post',
            'invalid-desktopfile',
            'standard-dir-owned-by-package',
            'use-tmp-in-%postun',
            'bogus-variable-use-in-%posttrans',
            'dir-or-file-in-usr-local',
            'dir-or-file-in-tmp',
            'dir-or-file-in-mnt',
            'dir-or-file-in-opt',
            'dir-or-file-in-home',
            'dir-or-file-in-var-local',
            'tmpfiles-conf-in-etc',
            'non-ghost-in-run',
            'non-ghost-in-var-run',
            'non-ghost-in-var-lock',
            'systemd-unit-in-etc',
            'udev-rule-in-etc',
        ],
    }

    # list of users allowed to submit packages when cauldron is frozen
    $cauldron_authorized_users = str_join(group_members('mga-release_managers'), '|')
    $cauldron_version_check = {
	'authorized_sections' => '^[a-z]+/updates_testing$',
	'authorized_packages' => '^$',
	'authorized_arches' => 'none',
	'authorized_users' => "^${cauldron_authorized_users}\$",
        'mode' => 'normal',
        #'mode' => 'version_freeze',
	#'mode' => 'freeze',
    }

    # for EOL distributions
    $frozen_version_check = {
	'authorized_packages' => 'none_package_authorized',
	'authorized_sections' => 'none_section_authorized',
	'authorized_arches' => 'none',
	'mode' => 'freeze',
    }

    # for supported stable distributions
    $std_version_check = {
	'authorized_packages' => 'none_package_authorized',
	'authorized_sections' => '^(core|nonfree|tainted)/(updates_testing|backports_testing)$',
	'authorized_arches' => 'none',
	'mode' => 'freeze',
    }

    $infra_authorized_users = str_join(group_members('mga-sysadmin'), '|')
    $infra_version_check = {
	'authorized_users' => "^${infra_authorized_users}\$",
	'mode' => 'freeze',
    }

    class { 'buildsystem::var::distros':
	default_distro => 'cauldron',
	distros => {
	    'cauldron' => {
		'arch' => $std_arch,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
		'branch' => 'Devel',
		'version' => '4',
		'submit_allowed' => "${svn_root_packages}/cauldron",
		'macros' => $std_macros,
		'repo_allow_from' => $repo_allow_from,
		'youri' => {
		    'upload' => {
			'targets' => $cauldron_youri_upload_targets,
			'checks' => {
			    'rpmlint' => $cauldron_rpmlint,
			},
		    },
		    'todo' => {
			'targets' => $cauldron_youri_todo_targets,
			'checks' => {
			    'rpmlint' => $cauldron_rpmlint,
			    'version' => $cauldron_version_check,
			},
		    },
		},
	    },

	    '1'        => {
		'arch' => $std_arch,
                'no_media_cfg_update' => true,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
		'branch' => 'Official',
		'version' => '1',
		'submit_allowed' => "${svn_root_packages}/updates/1",
		'macros' => $std_macros,
		'repo_allow_from' => $repo_allow_from,
		'youri' => {
		    'upload' => {
			'targets' => $std_youri_upload_targets,
			'checks' => {
			    'rpmlint' => $mga2_rpmlint,
			},
		    },
		    'todo' => {
			'targets' => $std_youri_todo_targets,
			'checks' => {
			    'rpmlint' => $mga2_rpmlint,
			    'version' => $frozen_version_check,
			},
		    },
		},
	    },

	    '2'        => {
		'arch' => $std_arch,
                'no_media_cfg_update' => true,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
		'branch' => 'Official',
		'version' => '2',
		'submit_allowed' => "${svn_root_packages}/updates/2",
		'macros' => $std_macros,
		'repo_allow_from' => $repo_allow_from,
		'youri' => {
		    'upload' => {
			'targets' => $std_youri_upload_targets,
			'checks' => {
			    'rpmlint' => $mga2_rpmlint,
			},
		    },
		    'todo' => {
			'targets' => $std_youri_todo_targets,
			'checks' => {
			    'rpmlint' => $mga2_rpmlint,
			    'version' => $std_version_check,
			},
		    },
		},
	    },

            '3'        => {
		'arch' => $std_arch,
		'no_media_cfg_update' => true,
		'medias' => $std_medias,
		'base_media' => $std_base_media,
		'branch' => 'Official',
		'version' => '3',
		'submit_allowed' => "${svn_root_packages}/updates/3",
		'macros' => $std_macros,
		'repo_allow_from' => $repo_allow_from,
		'youri' => {
		    'upload' => {
			'targets' => $std_youri_upload_targets,
			'checks' => {
			    'rpmlint' => $mga3_rpmlint,
			},
		    },
		    'todo' => {
			'targets' => $std_youri_todo_targets,
			'checks' => {
			    'rpmlint' => $mga3_rpmlint,
			    'version' => $std_version_check,
			},
		    },
		},
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
		'youri' => {
		    'upload' => {
			'targets' => $infra_youri_upload_targets,
			'checks' => {
			    'rpmlint' => $mga2_rpmlint,
			},
		    },
		    'todo' => {
			'targets' => $infra_youri_todo_targets,
			'checks' => {
			    'rpmlint' => $mga2_rpmlint,
			    'version' => $infra_version_check,
			},
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
		'youri' => {
		    'upload' => {
			'targets' => $infra_youri_upload_targets,
			'checks' => {
			    'rpmlint' => $mga2_rpmlint,
			},
		    },
		    'todo' => {
			'targets' => $infra_youri_todo_targets,
			'checks' => {
			    'rpmlint' => $mga2_rpmlint,
			    'version' => $infra_version_check,
			},
		    },
		},
	    },
	}
    }
    $checks_tag_options = {
	'tags' => {
	    'release' => inline_template("<%= std_macros['distsuffix'] %>\\d+"),
	    'distribution' => inline_template("^<%= std_macros['distribution'] %>"),
	    'vendor' => inline_template("^<%= std_macros['vendor'] %>$"),
	},
    }
    class { 'buildsystem::var::youri':
        packages_archivedir => "${buildsystem::var::scheduler::homedir}/old",
	youri_conf => {
	    'upload' => {
		'checks' => {
		    'tag' => {
			'options' => $checks_tag_options,
		    },
		    'rpmlint' => {
			'options' => {
			    'results' => [
				'buildprereq-use',
				'no-description-tag',
				'no-summary-tag',
				'non-standard-group',
				'non-xdg-migrated-menu',
				'percent-in-conflicts',
				'percent-in-dependency',
				'percent-in-obsoletes',
				'percent-in-provides',
				'summary-ended-with-dot',
				'unexpanded-macro',
				'unknown-lsb-keyword',
				'malformed-line-in-lsb-comment-block',
				'empty-%postun',
				'empty-%post',
				'invalid-desktopfile',
				'standard-dir-owned-by-package',
				'use-tmp-in-%postun',
				'bogus-variable-use-in-%posttrans',
				'dir-or-file-in-usr-local',
				'dir-or-file-in-tmp',
				'dir-or-file-in-mnt',
				'dir-or-file-in-opt',
				'dir-or-file-in-home',
				'dir-or-file-in-var-local',
			    ],
			},
		    },
		},
		'actions' => {
		    'mail' => {
			'options' => {
			    'to' => "changelog@ml.${::domain}",
			    'reply_to' => "mageia-dev@${::domain}",
			    'from' => "buildsystem-daemon@${::domain}",
			    'prefix' => 'RPM',
			},
		    },
		},
	    },
	    'todo' => {
		'checks' => {
		    'tag' => {
			'options' => $checks_tag_options,
		    },
		},
	    },
	}
    }
}
