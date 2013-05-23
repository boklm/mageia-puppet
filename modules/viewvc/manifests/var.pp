# $hostname:
#   vhost used by viewvc
# $tmpl_viewvc_conf:
#   path to /etc/viewvc.conf template file
class viewvc::var(
    $hostname = "svnweb.$::domain",
    $tmpl_viewvc_conf = 'viewvc/viewvc.conf'
) {
}
