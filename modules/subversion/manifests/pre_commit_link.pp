define subversion::pre_commit_link() {
    $scriptname = regsubst($name,'^.*/', '')
    file { $name:
        ensure => 'link',
        target => "/usr/local/share/subversion/pre-commit.d/$scriptname",
        mode   => '0755',
    }
}
