class rsnapshot {
    class base($confdir = '/backups/conf') {
	package { ['rsnapshot']: }

	file { $confdir:
	    ensure => directory,
	    owner => root,
	    group => root,
	    mode => 0700,
	}
    }

    # - 'backup' is an array of "source destination" to backup
    # - 'backup_script' is an array of "script destination"
    # - ${x}_interval is the number of hourly, daily, weekly, monthly
    #   backups that should be kept. If you don't want hourly, daily,
    #   weekly or monthly backups, set ${x}_interval to '0'
    define backup(
	$snapshot_root = '/backups',
	$one_fs = '1',
	$backup = [],
	$backup_script = [],
	$hourly_interval = '0',
	$daily_interval = '6',
	$weekly_interval = '4',
	$monthly_interval = '3'
    ) {
	file { "${rsnapshot::base::confdir}/${name}.conf":
	    owner => root,
	    group => root,
	    mode => 0700,
	    content => template('rsnapshot/rsnapshot.conf'),
	}
    }
}
