class repositories::svn_mirror {
    file { '/svn':
        ensure => directory,
    }

    subversion::mirror_repository {
        '/svn/adm/':       source => "svn://svn.$::domain/svn/adm/";
        '/svn/advisories/':source => "svn://svn.$::domain/svn/advisories/";
        '/svn/soft/':      source => "svn://svn.$::domain/svn/soft/";
        '/svn/web/':       source => "svn://svn.$::domain/svn/web/";
        '/svn/packages/':  source => "svn://svn.$::domain/svn/packages/";
        '/svn/org/':       source => "svn://svn.$::domain/svn/org/";
        '/svn/treasurer/': source => "svn://svn.$::domain/svn/treasurer/";
    }

    # no binrepos, too big to mirror
}
