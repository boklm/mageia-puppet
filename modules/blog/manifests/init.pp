class blog {
    user { "blog":
        groups => apache,
        comment => "This user is used for blog.mageia.org",
        ensure => present,
        managehome => true,
    }

    include apache::mod_php
    include mysql
    apache::vhost_other_app { "blog-test.$domain":
        vhost_file => "blog/01_blogs_vhosts.conf",
    }

    package { ['wget','php-mysql']:
        ensure => installed
    }

    file { "/var/lib/blog":
        ensure => directory,
        owner => blog,
        group => blog,
        mode => 644,
    }

    file { "check_new-blog-post":
        path => "/usr/local/bin/check_new-blog-post.sh",
        ensure => present,
        owner => blog,
        group => blog,
        mode => 755,
        content => template("blog/check_new-blog-post.sh")
    }

    file { "/var/www/html/blog.$domain":
	ensure => directory,
	owner => blog,
	group => blog,
	mode => 644,
    }
    
    cron { blog:
        user => blog,
        minute => '*/15',
        command => "/usr/local/bin/check_new-blog-post.sh",
        require => File["check_new-blog-post"]
    }
}
