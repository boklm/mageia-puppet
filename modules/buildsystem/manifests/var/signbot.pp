# $keyid:
#   the key id of the gnupg key used to sign packages
class buildsystem::var::signbot(
    $keyid
) {
    $login = 'signbot'
    $home_dir = "/var/lib/$login"
    $sign_keydir = "$home_dir/keys"
}
