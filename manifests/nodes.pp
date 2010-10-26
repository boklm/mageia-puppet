# svn, big important server
node valstar {
	include default_mageia_server
    # for puppet svn checkout
    package {"subversion":
        ensure => "installed"
    }

    # update the puppet snapshot 
    cron { puppet_update:
           command => "cd /etc/puppet && /usr/bin/svn update -q",
           user => root,
           minute => '*/5'
    }

    exec { puppet_etc:
        cwd => "/etc/",
        command => "/usr/bin/svn co svn://vm-gandi.mageia.org/adm/puppet/",
        user => "root",
        creates => "/etc/puppet/manifests/site.pp"
    }

    package {"puppet-server":
        ensure => "installed"
    }
}

# web apps
node alamut {
	include default_mageia_server
}

# buildnode
node jonund {
	include default_mageia_server
}

node ecosse {
	include default_mageia_server
}


# backup server
node fiona {
	include default_mageia_server
} 

# gandi-vm
node krampouezh {
	include default_mageia_server
}

node champagne {
	include default_mageia_server
}


