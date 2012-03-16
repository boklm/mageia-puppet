class buildsystem::scheduler {
        # until ulri is splitted from main iurt rpm
        include ssh::auth
        include iurt::packages
        include iurt::upload
        $login = 'schedbot'
        $homedir = $buildsystem::base::sched_home_dir

        ssh::auth::key { $login:
            # declare a key for sched bot: RSA, 2048 bits
            home => $sched_home_dir,
        }

        sshuser { $login:
            homedir => $homedir,
            comment => 'System user used to schedule builds',
        }
}
