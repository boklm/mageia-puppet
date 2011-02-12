class blog {

    user { "blog":
        groups => apache,
        comment => "User running cron jobs for blog",
        ensure => present,
        managehome => true,
        home => "/var/lib/blog",
    }

    package { ['wget','php-mysql']:
        ensure => installed
    }

    file { "check_new-blog-post":
        path => "/usr/local/bin/check_new-blog-post.sh",
        ensure => present,
        owner => root,
        group => root,
        mode => 755,
        content => template("blog/check_new-blog-post.sh")
    }
   
    cron { blog:
        user => blog,
        minute => '*/15',
        command => "/usr/local/bin/check_new-blog-post.sh",
        require => [File["check_new-blog-post"], User['blog']],
    }

    include apache::mod_php
    include mysql

    $blog_location = "/var/www/html/blog.$domain"
    $blog_domain = "blog-test.$domain"
    apache::vhost_other_app { "$blog_domain":
        vhost_file => "blog/blogs_vhosts.conf",
    }

    file { "$blog_location":
	    ensure => directory,
	    owner => blog,
	    # FIXME is the group created by puppet ?
        group => blog,
	    mode => 644,
    }
}
