class forums {

    phpbb::instance { "en": }

    phpbb::instance { "de": }

    phpbb::redirection_instance{ "fr":
       url => "https://forums.mageia.org/en/viewforum.php?f=19"
    }

    phpbb::redirection_instance{ "es":
       url => "https://forums.mageia.org/en/viewforum.php?f=22"
    }

    phpbb::redirection_instance{ "zh-cn":
       url => "https://forums.mageia.org/en/viewforum.php?f=27"
    }

    phpbb::redirection_instance{ "pt-br":
       url => "https://forums.mageia.org/en/viewforum.php?f=28"
    }
}
