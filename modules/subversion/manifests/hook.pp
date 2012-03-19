define subversion::hook($content, $type) {
    $array = split($name,'\|')
    $repo = $array[0]
    $script = $array[1]
    file { "$repo/hooks/$type.d/$script":
        content => $content,
        mode    => '0755',
    }
}
