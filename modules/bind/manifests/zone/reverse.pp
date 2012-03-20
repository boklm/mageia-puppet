define bind::zone::reverse($content = false) {
    bind::zone { $name :
        type    => 'reverse',
        content => $content,
    }
}
