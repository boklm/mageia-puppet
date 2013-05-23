define buildsystem::youri_submit_conf($tmpl_file) {
    $conf_name = $name
    file { "/etc/youri/submit-${conf_name}.conf":
	content => template($tmpl_file),
    }
}
