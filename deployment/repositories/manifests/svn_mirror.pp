class repositories::svn_mirror {
    file { "/svn":
        ensure => directory,
    }

    subversion::mirror_repository { "/svn/adm/":
        source => "svn://svn.$domain/svn/adm/"
    }

    subversion::mirror_repository { "/svn/soft/":
        source => "svn://svn.$domain/svn/soft/"
    }

    subversion::mirror_repository { "/svn/web/":
        source => "svn://svn.$domain/svn/web/"
    }

    subversion::mirror_repository { "/svn/packages/":
        source => "svn://svn.$domain/svn/packages/"
    }

    # no binrepos, too big to mirror
}

