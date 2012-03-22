# to not repeat the settings everywhere
Exec {
    path => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin/',
}

Package {
    ensure => present,
}

File {
    ensure => present,
    owner  => 'root',
    group  => 'root',
    # on directory, this will be 755
    # see http://docs.puppetlabs.com/references/2.7.0/type.html#file
    mode   => '0644',
}

Group {
    ensure => present,
}

User {
    ensure     => present,
    managehome => true,
    shell      => '/bin/bash',
}

Service {
    ensure => running,
}

define local_script($content,
                    $owner = 'root',
                    $group = 'root',
                    $mode = '0755') {
    file { "/usr/local/bin/$name":
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        content => $content,
    }
}
