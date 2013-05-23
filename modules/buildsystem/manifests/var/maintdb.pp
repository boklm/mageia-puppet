class buildsystem::var::maintdb(
    $hostname = "maintdb.$::domain",
    $login = 'maintdb',
    $homedir = '/var/lib/maintdb'
) {
    include buildsystem::var::webstatus
    $dbdir = "$homedir/db"
    $binpath = '/usr/local/sbin/maintdb'
    $dump = "${buildsystem::var::webstatus::location}/data/maintdb.txt"
    $unmaintained = "${buildsystem::var::webstatus::location}/data/unmaintained.txt"
}
