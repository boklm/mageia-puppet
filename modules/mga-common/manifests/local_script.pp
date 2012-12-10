define mga-common::local_script($content,
		$owner = 'root',
		$group = 'root',
		$mode = '0755') {
    file { "/usr/local/bin/$name":
	owner   => $owner,
	group   => $group,
	mode    => $mode,
	content => $content,
    }
}
