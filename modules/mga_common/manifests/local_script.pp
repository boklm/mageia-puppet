define mga_common::local_script(
                $content = undef,
                $source = undef,
		$owner = 'root',
		$group = 'root',
		$mode = '0755') {
    $filename = "/usr/local/bin/$name"
    file { $filename:
	owner   => $owner,
	group   => $group,
	mode    => $mode,
    }
    if ($source == undef) {
	File[$filename] {
	    content => $content,
	}
    } else {
	File[$filename] {
	    source => $source,
	}
    }
}
