class buildsystem::scheduler {
        # until ulri is splitted from main iurt rpm
        include ssh::auth
        include buildsystem::iurt::packages
        include buildsystem::iurt::upload
        include buildsystem::scheduler::var

        $login = $buildsystem::scheduler::var::login
        $homedir = $buildsystem::scheduler::var::homedir        

        ssh::auth::key { $login:
            # declare a key for sched bot: RSA, 2048 bits
            home => $homedir,
        }

        sshuser { $login:
            homedir => $homedir,
            comment => 'System user used to schedule builds',
        }
}
