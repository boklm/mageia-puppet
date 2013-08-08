class buildsystem::webstatus {
    include buildsystem::var::webstatus
    include buildsystem::var::scheduler
    include apache::mod::php

    file { [ $buildsystem::var::webstatus::location, "${buildsystem::var::webstatus::location}/data" ]:
        ensure => directory,
    }

    $vhost = $buildsystem::var::webstatus::hostname
    apache::vhost::base { $vhost:
        aliases  => {
            '/uploads' => "${buildsystem::var::scheduler::homedir}/uploads",
            '/autobuild/cauldron/x86_64/core/log/status.core.log' => "${buildsystem::var::webstatus::location}/autobuild/broken.php",
	    '/themes' => $buildsystem::var::webstatus::themes_dir,
        },
        location => $buildsystem::var::webstatus::location,
        content  => template('buildsystem/vhost_webstatus.conf'),
    }

    apache::vhost::base { "ssl_${vhost}":
        vhost    => $vhost,
        use_ssl  => true,
        aliases  => {
            '/uploads' => "${buildsystem::var::scheduler::homedir}/uploads",
            '/autobuild/cauldron/x86_64/core/log/status.core.log' => "${buildsystem::var::webstatus::location}/autobuild/broken.php",
	    '/themes' => $buildsystem::var::webstatus::themes_dir,
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
