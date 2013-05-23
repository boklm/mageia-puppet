# $httpdlogs_rotate:
#   number of time the log file are rotated before being removed
# $default_vhost_redirect:
#   URL to redirect to in case of unknown vhost
class apache::var(
    $httpdlogs_rotate = '24',
    $apache_user = 'apache',
    $apache_group = 'apache',
    $default_vhost_redirect = ''
) {
    if ($::lsbdistrelease == '1') or ($::lsbdistid == 'MandrivaLinux') {
        $pkg_conf = 'apache-conf'
    } else {
        $pkg_conf = 'apache'
    }
}
