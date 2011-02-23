
from django_auth_ldap.backend import LDAPBackend,_LDAPUser 

class ForceUidLDAPBackend(LDAPBackend):
    def ldap_to_django_username(self, username):
        # force uid if someone give a email
        return _LDAPUser(self, username=username).attrs['uid'][0]


