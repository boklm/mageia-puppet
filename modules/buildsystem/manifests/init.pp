class buildsystem {
    # A script to copy on valstar the 2010.1 rpms built on jonund
    class sync20101 inherits base {
        $build_login = $buildsystem::iurt::user::login
        # TODO user iurt::user::homedir too
        local_script { 'sync2010.1':
	        content => template('buildsystem/sync2010.1'),
        }
    }

    # a script to build 2010.1 packages. used on jonund
    class iurt20101 inherits base {
        $build_login = $buildsystem::iurt::user::login
        local_script { 'iurt2010.1':
	        content => template('buildsystem/iurt2010.1'),
        }
    }
}
