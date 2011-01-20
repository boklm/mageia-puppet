class shadow {
    file {"/etc/login.defs":
    	owner => 'root',
	group => 'shadow',
    	mode => 640,
	source => 'puppet:///modules/shadow/login.defs',
    }
}
