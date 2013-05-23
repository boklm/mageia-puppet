# $keyid:
#   the key id of the gnupg key used to sign packages
# $keyemail:
#   email address of the key used to sign packages
# $keyname:
#   name of the key used to sign packages
class buildsystem::var::signbot(
    $keyid,
    $keyemail,
    $keyname
) {
    $login = 'signbot'
    $home_dir = "/var/lib/$login"
    $sign_keydir = "$home_dir/keys"
}
