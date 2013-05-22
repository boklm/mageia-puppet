# $uploadmail_from:
#   from who will be sent the binrepo upload email notifications
# $uploadmail_to:
#   where binrepo email notifications are sent
class buildsystem::var::binrepo(
    $hostname = "binrepo.${::domain}",
    $login = 'binrepo',
    $homedir = '/var/lib/binrepo',
    $uploadmail_from,
    $uploadmail_to
) {
    $repodir = "$homedir/data"
    $uploadinfosdir = "$homedir/infos"
    $uploadbinpath = '/usr/local/bin/upload-bin'
}
