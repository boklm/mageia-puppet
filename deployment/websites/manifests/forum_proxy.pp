class buildsystem {
    class forum_proxy {
        $web_domain = "forums.$domain"
        
        host { "$web_domain":
            ip => '192.168.122.131',
            ensure => 'present',
        }

        apache::vhost_reverse_proxy { "$web_domain":
            url => "http://$web_domain/",
        } 

        apache::vhost_reverse_proxy { "ssl_$web_domain":
            vhost => $web_domain,
            use_ssl => true,
            url => "http://$web_domain/",
        } 
    }
}
