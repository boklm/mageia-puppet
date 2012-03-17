# the class is just here to handle global configuration
# a smart variation of the method exposed on 
# http://puppetlabs.com/blog/the-problem-with-separating-data-from-puppet-code/
class mediawiki::config(
	    $pgsql_password,
	    $secretkey,
	    $ldap_password,
	    $vhost = "wiki.$::domain",
        $root = '/srv/wiki/') {}
