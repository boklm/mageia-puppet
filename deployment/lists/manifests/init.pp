class lists {

        # please check that the list use the proper code for
        # language ( not to be confused with tld or country code )
        sympa::public_list {"i18n-af":
            subject => "List about translation to Afrikaans",
            topics => "i18n",
        }

        sympa::public_list {"i18n-de":
            subject => "List about translation to German",
            topics => "i18n",
        }

        sympa::public_list {"i18n-et":
            subject => "List about translation to Estonian",
            topics => "i18n",
        }

        sympa::public_list {"i18n-fr":
            subject => "List about translation to French",
            topics => "i18n",
        }

        sympa::public_list {"i18n-nl":
            subject => "List about translation to Dutch",
            topics => "i18n",
        }

        sympa::public_list {"i18n-pt_br":
            subject => "List about translation to Brazilian Portuguese",
            topics => "i18n",
        }

        sympa::public_list {"i18n-pl":
            subject => "List about translation to Polish",
            topics => "i18n",
        }

        sympa::public_list {"i18n-ru":
            subject => "List about translation to Russian",
            topics => "i18n",
        }

        sympa::public_list {"i18n-tr":
            subject => "List about translation to Turkish",
            topics => "i18n",
        }

        sympa::public_list {"i18n-it":
            subject => "List about translation to Italian",
            topics => "i18n",
        }

        sympa::public_list {"i18n-en":
            subject => "List about translation to English",
            topics => "i18n",
        }

        sympa::public_list {"i18n-ro":
            subject => "List about translation to Romanian",
            topics => "i18n",
        }

        sympa::public_list {"i18n-zh_tw":
            subject => "List about translation to Taiwanese",
            topics => "i18n",
        }

        sympa::announce_list_email {"packages-commits":
            subject => "List receiving commits mail from packages repository",
            # FIXME change once we migrate
            reply_to => "mageia-dev@$domain",
            sender_email => "root@$domain",
            topics => "developers",
        }

        sympa::announce_list_email {"mirrors-announce":
            subject => "Important announces about mirrors updates",
            # FIXME change once we migrate
            reply_to => "mageia-sysadm@$domain",
            sender_email => "root@$domain",
            topics => "sysadmin",
        }

        sympa::announce_list_email {"sysadmin-commits":
            subject => "List receiving commits mail from sysadmin team repository",
            # FIXME change once we migrate
            reply_to => "mageia-sysadm@$domain",
            sender_email => "root@$domain",
            topics => "sysadmin",
        }

        sympa::announce_list_email {"sysadmin-reports":
            subject => "List receiving automated reports from various pieces of infrastructure",
            # FIXME change once we migrate
            reply_to => "mageia-sysadm@$domain",
            sender_email => "root@$domain",
            topics => "sysadmin",
        }

        sympa::announce_list_email { "sysadmin-bugs":
            subject => "List receiving sysadmin bugs reports from bugzilla",
            # FIXME change once we migrate
            reply_to => "mageia-sysadm@$domain",
            sender_email => "bugzilla-daemon@$domain",
            topics => "sysadmin",
        }

        sympa::announce_list_email { "soft-commits":
            subject => "List receiving automated reports from soft/ repositories",
            # FIXME change once we migrate
            reply_to => "mageia-dev@$domain",
            sender_email => "root@$domain",
            topics => "developers",
        }

        sympa::announce_list_email { "bugs":
            subject => "List receiving bugs reports from bugzilla ",
            # FIXME change once we migrate
            reply_to => "mageia-dev@$domain",
            sender_email => "bugzilla-daemon@$domain",
            topics => "developers",
        }

        sympa::announce_list_email { "changelog":
            subject => "List receiving announces for new packages uploaded",
            # FIXME change once we migrate
            reply_to => "mageia-dev@$domain",
            sender_email => "buildsystem-daemon@$domain",
            topics => "developers",
        }

        # rda asked for a list where posting is restricted to a ldap
        # group, and where everybody can subscribe. While the name is not
        # really reflecting the usage, the functionnal requirements are fullfilled
        # FIXME people in the board group should be subscribed to this list
        #      
        sympa::announce_list_group { "board-public":
            subject => "List for public board discussion",
            reply_to => false,
            sender_ldap_group => "mga-board", 
            topics => "governance",
        }

        sympa::private_list { "board-private":
            subject => "List for private board discussion",
            subscriber_ldap_group => "mga-board",
            topics => "governance",
        }
 
        sympa::public_restricted_list { "council":
            subject => "Council list",
            subscriber_ldap_group => "mga-council",
            topics => "governance",
        }        
}
