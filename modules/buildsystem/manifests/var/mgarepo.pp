# $submit_host:
#   hostname used to submit packages
# $svn_hostname:
#   hostname of the svn server used for packages
# $svn_root_packages:
#   svn root url of the svn repository for packages
# $svn_root_packages_ssh:
#   svn+ssh root url of the svn repository for packages
# $oldurl:
#   svn url where the import logs of the rpm are stored
# $conf:
#    $conf{'global'} is a has table of values used in mgarepo.conf in
#    the [global] section
class buildsystem::var::mgarepo(
    $submit_host,
    $svn_hostname,
    $svn_root_packages,
    $svn_root_packages_ssh,
    $oldurl,
    $conf
) {
}
