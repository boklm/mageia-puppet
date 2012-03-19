# same as private_list, but post are restricted to $email
# ( scripting )
define sympa::private_list_email($subject,
                          $subscriber_ldap_group,
                          $sender_email,
                          $language ='en',
                          $topics = false) {
    list { $name:
        subject               => $subject,
        profile               => '',
        language              => $language,
        topics                => $topics,
        subscriber_ldap_group => $subscriber_ldap_group,
        sender_email          => $sender_email,
        public_archive        => false,
    }
}
