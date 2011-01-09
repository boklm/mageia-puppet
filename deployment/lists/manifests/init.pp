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
}
