define subversion::hook::post_commit($content) {
    hook { $name:
        content => $content,
        type    => 'post-commit',
    }
}
