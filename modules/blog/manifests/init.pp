#TODO: 
# - add the creation of the user 'blog' in puppet
class blog {
	package { 'mysql':
        	ensure => installed
    	}

        package { 'wget':
                ensure => installed
        }

    	package { 'php-mysql':
        	ensure => installed
    	}

	service { mysqld:
        	ensure => running,
        	subscribe => Package["mysql"],
    	}
	
	file { "check_new-blog-post":
        	path => "/usr/local/bin/check_new-blog-post.sh",
        	ensure => present,
        	owner => blog,
        	group => blog,
        	mode => 755,
        	content => template("blog/check_new-blog-post.sh")
    	}

	file { "/var/lib/blog":
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
