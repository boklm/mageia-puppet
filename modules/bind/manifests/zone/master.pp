define bind::zone::master($content = false) {
    bind::zone { $name :
        type    => 'master',
        content => $content,
    }
}
