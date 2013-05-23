class buildsystem::webstatus {
    include buildsystem::var::webstatus
    include buildsystem::var::scheduler

    file { [ $buildsystem::var::webstatus::location, "${buildsystem::var::webstatus::location}/data" ]:
        ensure => directory,
    }

    apache::vhost::base { $buildsystem::var::webstatus::hostname:
        aliases  => {
            '/uploads' => "${buildsystem::var::scheduler::homedir}/uploads",
            '/autobuild/cauldron/x86_64/core/log/status.core.log' => "$location/autobuild/broken.php"
        },
        location => $buildsystem::var::webstatus::location,
        content  => template('buildsystem/vhost_webstatus.conf'),
    }

    subversion::snapshot { $buildsystem::var::webstatus::location:
        source => $buildsystem::var::webstatus::svn_url,
    }

    file { '/etc/bs-webstatus.conf':
	ensure => present,
	content => template('buildsystem/bs-webstatus.conf'),
	mode => 0644,
	owner => root,
	group => root,
    }
}
