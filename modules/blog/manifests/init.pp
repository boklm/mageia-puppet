class blog {

    class base {
        user { "blog":
        groups => apache,
        comment => "Mageia Blog",
        ensure => present,
        managehome => true,
        home => "/var/lib/blog",
        }
    }
    
    class files-bots inherits base {
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
   
        cron { "Blog bot":
            user => blog,
            minute => '*/15',
            command => "/usr/local/bin/check_new-blog-post.sh",
            require => [File["check_new-blog-post"], User['blog']],
        }

        include apache::mod_php

        $blog_location = "/var/www/html/blog.$domain"
        $blog_domain = "blog.$domain"

        apache::vhost_base { "$blog_domain":
            location => $blog_location,
            content => template('blog/blogs_vhosts.conf'),
        }

        apache::vhost_base { "ssl_$blog_domain":
            use_ssl => true,
            vhost => $blog_domain,
            location => $blog_location,
            content => template('blog/blogs_vhosts.conf'),
        }

        file { "$blog_location":
	        ensure => directory,
	        owner => apache,
	        group => apache,
	        mode => 644,
        }
    }
    class db_backup inherits base {
        file { "/var/lib/blog/backup":
                ensure => directory,
                owner => root,
                group => root,
                mode => 644,
        }

	file { "backup_blog-db":
            path => "/usr/local/bin/backup_blog-db.sh",
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template("blog/backup_blog-db.sh")
        }

        cron { "Backup DB (blog)":
            user => root,
            hour => '23',
            minute => '42',
            command => "/usr/local/bin/backup_blog-db.sh",
            require => [File["backup_blog-db"]],
        }
    }
    class files_backup inherits base {
        file { "/var/lib/blog/backup":
                ensure => directory,
                owner => root,
                group => root,
                mode => 644,
        }

        file { "backup_blog-files":
            path => "/usr/local/bin/backup_blog-files.sh",
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template("blog/backup_blog-files.sh")
        }

        cron { "Backup files (blog)":
            user => root,
            hour => '23',
            minute => '42',
            command => "/usr/local/bin/backup_blog-files.sh",
            require => [File["backup_blog-files"]],
        }
    }
}
