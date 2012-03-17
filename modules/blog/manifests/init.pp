class blog {

    class base {
        $blog_location = "/var/www/vhosts/blog.$domain"
        $blog_domain = "blog.$domain"
	$blog_db_backupdir = "/var/lib/backups/blog_db"
	$blog_files_backupdir = "/var/lib/backups/blog_files"

        user { "blog":
        groups => apache,
        comment => "Mageia Blog",
        home => "/var/lib/blog",
        }
    }
    
    class files-bots inherits base {
        package { ['wget','php-mysql','php-ldap','unzip']:
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
        file { $blog_db_backupdir:
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
        file { $blog_files_backupdir:
                ensure => directory,
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
