class buildsystem::scheduler {
        # until ulri is splitted from main iurt rpm
        include buildsystem::iurt::packages
        include buildsystem::iurt::upload
        include buildsystem::var::scheduler

        $login = $buildsystem::var::scheduler::login
        $homedir = $buildsystem::var::scheduler::homedir        
	$logdir = $buildsystem::var::scheduler::logdir

        buildsystem::sshuser { $login:
            homedir => $homedir,
            comment => 'System user used to schedule builds',
        }

	file { $logdir:
	    ensure => directory,
	    mode => 0755,
	    owner => $login,
	}

	cron { 'dispatch jobs':
	    user    => $login,
	    command => "ULRI_LOG_FILE=$logdir/ulri.log ulri; EMI_LOG_FILE=$logdir/emi.log emi",
	    minute  => '*',
	}
}
