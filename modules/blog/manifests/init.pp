#TODO: 
# - add the creation of the user 'blog' in puppet
class blog {
	include apache::mod_php
    include mysql

    package { ['wget','php-mysql']:
        ensure => installed
    }

    file { "check_new-blog-post":
        path => "/usr/local/bin/check_new-blog-post.sh",
        ensure => present,
        owner => blog,
        group => blog,
        mode => 755,
        content => template("blog/check_new-blog-post.sh")
    }

    file { "01_blogs_vhosts.conf":
        path => "/etc/httpd/conf/vhosts.d/",
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        content => template("blog/01_blogs_vhosts.conf")
    }

    file { "/var/lib/blog":
        ensure => directory,
        owner => blog,
        group => blog,
        mode => 644,
    }
    
    file { "/var/www/html/blog.mageia.org":
	ensure => directory,
	owner => blog,
	group => apache,
	mode => 644,
    }
    
    cron { blog:
        user => blog,
        minute => '*/15',
        command => "/usr/local/bin/check_new-blog-post.sh",
        require => File["check_new-blog-post"]
    }
}
