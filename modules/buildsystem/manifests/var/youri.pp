# The youri configuration files are created using informations from 3
# different hash variables :
# - the $youri_conf_default variable defined in this class, containing
#   the default configuration for youri. It contais the repository
#   configuration, and the definitions of the checks, actions and posts.
# - the $youri_conf parameter passed to this class. The values defined
#   in this hash override the values defined in the default configuration.
# - for each distribution defined in the hash variable $distros from
#   var::buildsystem::distros the hash defined in index 'youri' contains
#   some distro specific options for youri checks, actions or posts. It
#   also contains for each distribution the list of active checks,
#   actions and posts.
#
# Each of those variables contain the configuration for youri submit-todo
# (in index 'todo') and youri submit-upload (in index 'upload')
#
# 
# Parameters :
# $tmpl_youri_upload_conf:
#   template file for youri submi-upload.conf
# $tmpl_youri_todo_conf:
#   template file for youri submit-todo.conf
# $packages_archivedir:
#   the directory where youri will archive old packages when they are
#   replaced by a new version
# $youri_conf:
#   a hash containing the youri configuration
class buildsystem::var::youri(
    $tmpl_youri_upload_conf = 'buildsystem/youri/submit.conf',
    $tmpl_youri_todo_conf = 'buildsystem/youri/submit.conf',
    $packages_archivedir,
    $youri_conf = {}
) {
    include buildsystem::var::repository
    include buildsystem::var::mgarepo
    include buildsystem::var::distros
    include buildsystem::var::signbot
    include buildsystem::var::scheduler

    $check_tag = { 'class' => 'Youri::Submit::Check::Tag', }
    $check_recency = { 'class' => 'Youri::Submit::Check::Recency', }
    $check_queue_recency = { 'class' => 'Youri::Submit::Check::Queue_recency', }
    $check_host = {
	'class' => 'Youri::Submit::Check::Host',
	'options' => {
	    'host_file' => '/etc/youri/host.conf',
	},
    }
    $check_rpmlint = { 'class' => 'Youri::Submit::Check::Rpmlint', }
    $check_acl = {
	'class' => 'Youri::Submit::Check::ACL',
	'options' => {
	    'acl_file' => '/etc/youri/acl.conf',
	},
    }
    $check_source = { 'class' => 'Youri::Submit::Check::Source', }
    $check_version = {
	'class' => 'Youri::Submit::Check::Version',
	'options' => {},
    }

    $youri_conf_default = {
	'upload' => {
	    'repository' => {
		'class' => 'Youri::Repository::Mageia',
		'options' => {
		    'install_root' => $buildsystem::var::repository::bootstrap_reporoot,
		    'upload_root' => '${home}/uploads/',
		    'archive_root' => $packages_archivedir,
		    'upload_state' => 'queue',
		    'queue' => 'queue',
		    'noarch' => 'i586',
		    'svn' => "${buildsystem::var::mgarepo::svn_root_packages_ssh}/${buildsystem::var::distros::default_distro}",
		},
	    },
	    'checks' => {
		'tag' => $check_tag,
		'recency' => $check_recency,
		'queue_recency' => $check_queue_recency,
		'host' => $check_host,
		'section' => {
		    'class' => 'Youri::Submit::Check::Section',
		},
		'rpmlint' => $check_rpmlint,
		'svn' => {
		    'class' => 'Youri::Submit::Check::SVN',
		},
		'acl' => $check_acl,
		'history' => {
		    'class' => 'Youri::Submit::Check::History',
		},
		'source' => $check_source,
		'precedence' => {
		    'class' => 'Youri::Submit::Check::Precedence',
		    'options' => {
			'target' => $buildsystem::var::distros::default_distro,
		    },
		},
		'version' => $check_version,
	    },
	    'actions' => {
		'install' => {
		    'class' => 'Youri::Submit::Action::Install',
		},
		'markrelease' => {
		    'class' => 'Youri::Submit::Action::Markrelease',
		},
		'link' => {
		    'class' => 'Youri::Submit::Action::Link',
		},
		'archive' => {
		    'class' => 'Youri::Submit::Action::Archive',
		},
		'clean' => {
		    'class' => 'Youri::Submit::Action::Clean',
		},
		'sign' => {
		    'class' => 'Youri::Submit::Action::Sign',
		    'options' => {
			'signuser' => $buildsystem::var::signbot::login,
			'path' => $buildsystem::var::signbot::sign_keydir,
			'name' => $buildsystem::var::signbot::keyid,
			'signscript' => '/usr/local/bin/sign-check-package',
		    },
		},
		'unpack_gfxboot_theme' => {
		    'class' => 'Youri::Submit::Action::Unpack',
		    'options' => {
			'name' => 'mageia-gfxboot-theme',
			'source_subdir' => '/usr/share/gfxboot/themes/Mageia/install/',
			'dest_directory' => 'isolinux',
			'unpack_inside_distribution_root' => '1',
		    },
		},
		'unpack_meta_task' => {
		    'class' => 'Youri::Submit::Action::Unpack',
		    'options' => {
			'name' => 'meta-task',
			'source_subdir' => '/usr/share/meta-task',
			'dest_directory' => 'media/media_info',
			'unpack_inside_distribution_root' => '1',
		    },
		},
		'unpack_installer_images' => {
		    'class' => 'Youri::Submit::Action::Unpack',
		    'options' => {
			'name' => 'drakx-installer-images',
			'source_subdir' => '/usr/lib*/drakx-installer-images',
			'dest_directory' => '.',
			'preclean_directory' => 'install/images/alternatives',
			'unpack_inside_distribution_root' => '1',
		    },
		},
		'unpack_installer_images_nonfree' => {
		    'class' => 'Youri::Submit::Action::Unpack',
		    'options' => {
			'name' => 'drakx-installer-images-nonfree',
			'source_subdir' => '/usr/lib*/drakx-installer-images',
			'dest_directory' => '.',
			'unpack_inside_distribution_root' => '1',
		    },
		},
		'unpack_installer_stage2' => {
		    'class' => 'Youri::Submit::Action::Unpack',
		    'options' => {
			'name' => 'drakx-installer-stage2',
			'source_subdir' => '/usr/lib*/drakx-installer-stage2',
			'dest_directory' => '.',
			'unpack_inside_distribution_root' => '1',
		    },
		},
		'unpack_installer_advertising' => {
		    'class' => 'Youri::Submit::Action::Unpack',
		    'options' => {
			'name' => 'drakx-installer-advertising',
			'source_subdir' => '/usr/share/drakx-installer-advertising',
			'dest_directory' => '.',
			'unpack_inside_distribution_root' => '1',
		    },
		},
		'unpack_installer_rescue' => {
		    'class' => 'Youri::Submit::Action::Unpack',
		    'options' => {
			'name' => 'drakx-installer-rescue',
			'source_subdir' => '/usr/lib*/drakx-installer-rescue',
			'dest_directory' => 'install/stage2',
			'unpack_inside_distribution_root' => '1',
		    },
		},
		'unpack_release_notes' => {
		    'class' => 'Youri::Submit::Action::Unpack',
		    'options' => {
			'name' => 'mageia-release-common',
			'source_subdir' => '/usr/share/doc/mageia-release-common',
			'grep_files' => 'release-notes.*',
			'dest_directory' => '.',
			'unpack_inside_distribution_root' => '1',
		    },
		},
		'unpack_syslinux' => {
		    'class' => 'Youri::Submit::Action::Unpack',
		    'options' => {
			'name' => 'syslinux',
			'source_subdir' => '/usr/lib/syslinux/',
			'grep_files' => 'hdt.c32',
			'dest_directory' => 'isolinux',
			'unpack_inside_distribution_root' => '1',
		    },
		},
		'mail' => {
		    'class' => 'Youri::Submit::Action::Mail',
		    'options' => {
			'mta' => '/usr/sbin/sendmail',
		    },
		},
		'maintdb' => {
		    'class' => 'Youri::Submit::Action::UpdateMaintDb',
		},
		'rebuild' => {
		    'class' => 'Youri::Submit::Action::RebuildPackage',
		    'options' => {
			'rules' => {
			    'drakx-installer-binaries' => ['drakx-installer-images'],
			    'kernel' => ['drakx-installer-images', 'kmod-virtualbox', 'kmod-xtables-addons'],
			    'perl' => ['drakx-installer-stage2'],
			    'rpm' => ['drakx-installer-stage2'],
			},
		    },
		},
	    },
	    'posts' => {
		'genhdlist2' => {
		    'class' => 'Youri::Submit::Post::Genhdlist2',
		    'options' => {
			'command' => '/usr/bin/genhdlist2',
		    },
		},
		'clean_rpmsrate' => {
		    'class' => 'Youri::Submit::Post::CleanRpmsrate',
		},
		'mirror' => {
		    'class' => 'Youri::Submit::Post::Mirror',
		    'options' => {
			'destination' => $buildsystem::var::repository::mirror_reporoot,
		    },
		},
	    },
	},
	'todo' => {
	    'repository' => {
		'class' => 'Youri::Repository::Mageia',
		'options' => {
		    'install_root' => $buildsystem::var::repository::bootstrap_reporoot,
		    'upload_root' => '${home}/uploads/',
		    'upload_state' => 'todo done queue',
		    'queue' => 'todo',
		    'noarch' => 'i586',
		    'svn' => "${buildsystem::var::mgarepo::svn_root_packages_ssh}/${buildsystem::var::distros::default_distro}",
		},
	    },
	    'checks' => {
		'tag' => $check_tag,
		'recency' => $check_recency,
		'queue_recency' => $check_queue_recency,
		'host' => $check_host,
		'rpmlint' => $check_rpmlint,
		'acl' => $check_acl,
		'source' => $check_source,
		'version' => $check_version,
		'deps' => {
		    'class' => 'Youri::Submit::Check::Deps',
		},
	    },
	    'actions' => {
		'send' => {
		    'class' => 'Youri::Submit::Action::Send',
		    'options' => {
			'user' => $buildsystem::var::scheduler::login,
			'keep_svn_release' => 'yes',
			'uphost' => $buildsystem::var::scheduler::pkg_uphost,
			'root' => '${home}/uploads',
			'ssh_key' => '${home}/.ssh/id_rsa',
		    },
		},
		'rpminfo' => {
		    'class' => 'Youri::Submit::Action::Rpminfo',
		    'options' => {
			'user' => $buildsystem::var::scheduler::login,
			'uphost' => $buildsystem::var::scheduler::pkg_uphost,
			'root' => '${home}/uploads',
			'ssh_key' => '${home}/.ssh/id_rsa',
		    },
		},
		'ulri' => {
		    'class' => 'Youri::Submit::Action::Ulri',
		    'options' => {
			'user' => $buildsystem::var::scheduler::login,
			'uphost' => $buildsystem::var::scheduler::pkg_uphost,
			'ssh_key' => '${home}/.ssh/id_rsa',
		    },
		},
	    },
	    'posts' => {
	    },
	},
    }
}
