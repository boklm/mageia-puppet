class backups {
    class server {

	$backups_dir = '/backups'
	$confdir = "${backups_dir}/conf"

	class { 'rsnapshot::base':
	    confdir => $confdir,
	}

	file { $backups_dir:
	    ensure => directory,
	    owner => root,
	    group => root,
	    mode => 700,
	}

	rsnapshot::backup{ 'alamut':
	    snapshot_root => "${backups_dir}/alamut",
	    backup => [ 'root@alamut.mageia.org:/srv/wiki wiki' ],
	}
    }
}
