define subversion::hook::pre_commit($content) {
    hook { $name:
        content => $content,
        type    => 'pre-commit',
    }
}
