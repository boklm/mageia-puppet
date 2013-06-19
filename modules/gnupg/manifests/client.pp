class gnupg::client {
    package {['gnupg',
              'rng-utils']:
    }

    mga_common::local_script { 'create_gnupg_keys.sh':
        content => template('gnupg/create_gnupg_keys.sh')
    }
}


