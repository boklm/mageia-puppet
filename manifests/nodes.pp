# svn, big important server
node valstar {
	include default_mageia_server
    timezone { "Europe/Paris": }

    # for puppet svn checkout
    package {"subversion":
        ensure => "installed"
    }

    # svn spam log with 
    # Oct 26 13:30:01 valstar svn: No worthy mechs found
    # without it, source http://mail-index.netbsd.org/pkgsrc-users/2008/11/23/msg008706.html 
    # 
    package {"sasl-plug-anonymous":
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
    timezone { "Europe/Paris": }
	include default_mageia_server
}

# buildnode
node jonund {
    timezone { "Europe/Paris": }
	include default_mageia_server
}

node ecosse {
    timezone { "Europe/Paris": }
	include default_mageia_server
}


# backup server
node fiona {
	include default_mageia_server
} 

# gandi-vm
node krampouezh {
    timezone { "Europe/Paris": }
	include default_mageia_server
}

node champagne {
	include default_mageia_server
}


