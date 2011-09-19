class buildsystem {
    class release {
        subversion::snapshot { "/root/release":
            source => "svn://svn.$domain/soft/release/trunk/",
        }

        package { "hardlink":
            ensure => "installed",
        }
    }
}
