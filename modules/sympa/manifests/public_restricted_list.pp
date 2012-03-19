# list where only people from the ldap_group can post, ad where
# they are subscribed by default, but anybody else can subscribe
# to read and receive messages
define sympa::public_restricted_list( $subject,
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
        subscription_open     => true,
    }
}
