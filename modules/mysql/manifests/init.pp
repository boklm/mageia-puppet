class mysql {
    class server {
        package { "mysql":
            ensure => installed
        }

        service { "mysql":
            path => "/etc/init.d/mysqld",
            ensure => running,
            hasstatus => true, 
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
