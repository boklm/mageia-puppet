class websites::maintenance {
    $vhostdir = "$websites::base::webdatadir/maintenance"

    file {$vhostdir:
        ensure => 'directory',
        mode   => '0755',
        owner  => 'root',
        group  => 'root',
    }

    file {"$vhostdir/index.html":
        ensure => 'present',
        mode   => '0644',
        owner  => 'root',
        group  => 'root',
        source => 'puppet:///deployment/websites/maintenance.html',
    }

    apache::vhost::other_app { "maintenance.$::domain":
        vhost_file => 'websites/vhost_maintenance.conf',
    }
}
