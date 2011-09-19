class buildsystem {
    class check_missing_deps {
        file { "/usr/local/bin/missing-deps.sh":
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            source => "puppet:///modules/buildsystem/missing-deps.sh",
        }
    
        # FIXME hardcoded path
        cron { "check missing deps":
            command => "cd /var/www/bs/data && /usr/local/bin/missing-deps.sh",
            minute => "*/15",
        }
    }
}

