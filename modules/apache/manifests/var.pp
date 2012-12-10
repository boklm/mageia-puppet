# $httpdlogs_rotate:
#   number of time the log file are rotated before being removed
class apache::var(
    $httpdlogs_rotate = '24',
    $apache_user = 'apache',
    $apache_group = 'apache'
) {}
