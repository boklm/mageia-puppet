# list where announce are sent by member of ldap_group
# reply_to is set to $reply_to
define sympa::announce_list_group($subject,
                                  $reply_to,
                                  $sender_ldap_group,
                                  $language = 'en',
                                  $topics = false) {
    # profile + scenario
    list { $name:
        subject           => $subject,
        profile           => '',
        language          => $language,
        topics            => $topics,
        reply_to          => $reply_to,
        sender_ldap_group => $sender_ldap_group,
    }
}
