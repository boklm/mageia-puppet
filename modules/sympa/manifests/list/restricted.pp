# list where people cannot subscribe, where people from $ldap_group receive
# mail, with public archive
define sympa::list::restricted($subject,
                              $subscriber_ldap_group,
                              $language = 'en',
                              $topics = false) {
    list { $name:
        subject               => $subject,
        profile               => '',
        topics                => $topics,
        language              => $language,
        subscriber_ldap_group => $subscriber_ldap_group,
        sender_ldap_group     => $subscriber_ldap_group,
    }
}
