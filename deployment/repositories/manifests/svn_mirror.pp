class repositories::svn_mirror {
    file { '/svn':
        ensure => directory,
    }

    subversion::mirror_repository {
        '/svn/adm/':      source => "svn://svn.$::domain/svn/adm/";
        '/svn/soft/':     source => "svn://svn.$::domain/svn/soft/";
        '/svn/web/':      source => "svn://svn.$::domain/svn/web/";
        '/svn/packages/': source => "svn://svn.$::domain/svn/packages/";
    }

    # no binrepos, too big to mirror
}
