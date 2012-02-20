define icecream::client($host => '') {
    include icecream::client_common
    file { '/etc/sysconfig/icecream':
        content => template('icecream/sysconfig'),
    }
}
