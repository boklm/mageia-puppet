define git::mirror( $source,
                    $description,
                    $refresh = '*/5') {

    include git::common
    exec { "/usr/bin/git clone --bare $source $name":
        alias   => "git mirror $name",
        creates => $name,
        before  => File["$name/description"],
    }

    file { "$name/description":
        content => $description,
    }

    cron { "update $name":
        command => "cd $name ; /usr/bin/git fetch -q",
        minute  => $refresh
    }
}
