class websites::base {
    $webdatadir = '/var/www/vhosts'
    file { $webdatadir:
	ensure => directory,
	mode => 0755,
	owner => root,
	group => root
    }
}
