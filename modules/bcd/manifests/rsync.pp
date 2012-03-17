class bcd::rsync {
    include bcd::base
    $public_isos = $bcd::variable::public_isos
    class { rsyncd:
		rsyncd_conf => 'bcd/rsyncd.conf',
	}
}
