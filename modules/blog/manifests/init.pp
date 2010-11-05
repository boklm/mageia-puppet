#TODO: add the creation of the user 'blog' in puppet
class blog {
	package { 'wget':
        	ensure => installed
    	}
	package { 'postfix':
                ensure => installed
        }
	file { "check_new-blog-post":
        	path => "/home/blog/check_new-blog-post.sh",
        	ensure => present,
        	owner => blog,
        	group => blog,
        	mode => 755,
        	content => template("blog/check_new-blog-post.sh")
    	}
	cron { blog:
        	user => blog,
        	hour => 0,
        	minute => 15,
        	command => "/home/blog/check_new-blog-post.sh",
        	require => File["check_new-blog-post"],
    	}
}
