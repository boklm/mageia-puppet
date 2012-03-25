class blog {
    class base {
        $blog_domain = "blog.$::domain"
        $blog_location = "/var/www/vhosts/$blog_domain"
        $blog_db_backupdir = "/var/lib/backups/blog_db"
        $blog_files_backupdir = "/var/lib/backups/blog_files"

        user { 'blog':
            groups  => apache,
            comment => 'User to run script checking for new blog post',
            home    => '/var/lib/blog',
        }
    }
    
    class files-bots inherits base {
        package { ['wget',
                   'php-mysql',
                   'php-ldap',
                   'unzip']: }

        local_script { 'check_new-blog-post.sh':
            content => template('blog/check_new-blog-post.sh'),
        }

        cron { 'Blog bot':
            user    => 'blog',
            minute  => '*/15',
            command => '/usr/local/bin/check_new-blog-post.sh',
            require => Local_script['check_new-blog-post.sh'],
        }

        include apache::mod::php

        apache::vhost::base { "$blog_domain":
            location => $blog_location,
            content => template('blog/blogs_vhosts.conf'),
        }

        apache::vhost::base { "ssl_$blog_domain":
            use_ssl => true,
            vhost => $blog_domain,
            location => $blog_location,
            content => template('blog/blogs_vhosts.conf'),
        }

        file { $blog_location:
	        ensure => directory,
	        owner => apache,
	        group => apache,
        }
    }

    class db_backup inherits base {
        file { $blog_db_backupdir:
                ensure => directory,
        }

	    local_script { 'backup_blog-db.sh':
            content => template('blog/backup_blog-db.sh'),
        }

        cron { "Backup DB (blog)":
            user    => root,
            hour    => '23',
            minute  => '42',
            command => '/usr/local/bin/backup_blog-db.sh',
            require => Local_script['backup_blog-db'],
        }
    }

    class files_backup inherits base {
        file { $blog_files_backupdir:
                ensure => directory,
        }

        local_script { 'backup_blog-files.sh':
            content => template('blog/backup_blog-files.sh'),
        }

        cron { 'Backup files (blog)':
            user    => root,
            hour    => '23',
            minute  => '42',
            command => '/usr/local/bin/backup_blog-files.sh',
            require => Local_script['backup_blog-files'],
        }
    }
}
