class tld_redirections {
    define domain {
        dns::zone { "mageia.$name": }
    }

    define redirection($managed_dns = false) {

        if ($managed_dns) {
            @@tld_redirections::domain { $name: } 
        }

        apache::vhost_redirect { "mageia.$name":
            url => "http://www.mageia.org/?fromtld=$name"
        }

        apache::vhost_redirect { "www.mageia.$name":
            url => "http://www.mageia.org/?fromtld=$name"
        }
    }

    # domaine owned by Florin Catalin Russen
    redirection { "ro": }

    # domain owned by the association
    redirection { "fr": }
}
