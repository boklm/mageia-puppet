class subversion {
    class hook {
        define post_commit($content) {
            commit_hook { $name:
                content => $content,
                type => "post-commit",
            }
        }
        define pre_commit($content) {
            commit_hook { $name:
                content => $content,
                type => "pre-commit",
            }
        }
  
        define commit_hook($content, $type) {
            $array = split($name,'\|')
            $repos = $array[0]
            $script = $array[1]
            file { "$repo/hook/$type.d/$script":
                content => $content,
                mode => 755,
            }
        }
    }
}
