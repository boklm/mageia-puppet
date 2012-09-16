class rsnapshot {
    class base($confdir = '/backups/conf') {
	package { ['rsnapshot']: }

	file { $confdir:
	    ensure => directory,
	    owner => root,
	    group => root,
	    mode => 0700,
	}

	@rsnapshot::cron_file { 'hourly': }
	@rsnapshot::cron_file { 'daily': }
	@rsnapshot::cron_file { 'weekly': }
	@rsnapshot::cron_file { 'monthly': }
    }

    define cron_file($rsnapshot_conf = []) {
	$filepath = "/tmp/cron.${name}_rsnapshot-backups"
	$rsnapshot_arg = ${name}
	file { $filepath:
	    ensure => present,
	    content => template('rsnapshot/cron_file'),
	    owner => root,
	    group => root,
	    mode => 0755,
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
	$conffile = "${rsnapshot::base::confdir}/${name}.conf"
	file { $conffile:
	    owner => root,
	    group => root,
	    mode => 0700,
	    content => template('rsnapshot/rsnapshot.conf'),
	}

	if ($hourly_interval != '0') {
	    Rsnapshot::Cron_file <| title == 'hourly' |> {
		$rsnapshot_conf +> $conffile,
	    }
	}
	if ($daily_interval != '0') {
	    Rsnapshot::Cron_file <| title == 'daily' |> {
		$rsnapshot_conf +> $conffile,
	    }
	}
	if ($dweekly_interval != '0') {
	    Rsnapshot::Cron_file <| title == 'weekly' |> {
		$rsnapshot_conf +> $conffile,
	    }
	}
	if ($monthly_interval != '0') {
	    Rsnapshot::Cron_file <| title == 'monthly' |> {
		$rsnapshot_conf +> $conffile,
	    }
	}
    }
}
