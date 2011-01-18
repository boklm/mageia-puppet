#TODO: 
# - add the creation of the user 'blog' in puppet
# - add the user 'blog' to the 'apache' group (usermod -a -G apache blog)
class blog {
    include apache::mod_php
    include mysql

    package { ['wget','mod_rewrite','php-mysql']:
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

    apache::vhost_other_app { "blog-test.$domain":
        vhost_file => "blog/01_blogs_vhosts.conf",
    }

    file { "/var/lib/blog":
        ensure => directory,
        owner => apache,
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
