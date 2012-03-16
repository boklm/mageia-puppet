class buildsystem::scheduler {
        # until ulri is splitted from main iurt rpm
        include iurt::packages
        include iurt::upload
        $login = $buildsystem::base::sched_login
        $homedir = $buildsystem::base::sched_home_dir

        sshuser { $login:
            homedir => $homedir,
            comment => 'System user used to schedule builds',
        }
}
