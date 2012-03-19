class gnupg::client {
    package {['gnupg',
              'rng-utils']:
    }

    local_script { 'create_gnupg_keys.sh':
        content => template('gnupg/create_gnupg_keys.sh')
    }
}


