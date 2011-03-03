class mysql {
    class server {
        package { "mysql":
            ensure => installed
        }

        service { mysqld:
	    alias => mysql,
            ensure => running,
	    subscribe => [ Package['mysql'] ],
        }
        
#        file { "/etc/my.cnf":
#            
#        }
    }
    
    define database() { 
       exec { "mysqladmin create $name":
            user => root,
           # not sure if /dev/null is needed
           unless => "mysqlshow $name"
       }
    }
#    define user($password) {
#
#    }
}
