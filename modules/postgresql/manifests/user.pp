# TODO convert to a regular type, so we can later change password
# without erasing the current user
define postgresql::user($password) {
    $sql = "CREATE ROLE $name ENCRYPTED PASSWORD '\$pass' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;"

    exec { "psql -U postgres -c \"$sql\" ":
        user        => 'root',
        # do not leak the password on commandline
        environment => "pass=$password",
        unless      => "psql -A -t -U postgres -c '\\du $name' | grep '$name'",
        require     => Service['postgresql'],
    }
}
