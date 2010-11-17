#!/usr/bin/python

import sys
import os
import random

try:
    import ldap
except ImportError, e:
    print "Please install python-ldap before running this program"
    sys.exit(1)

basedn="dc=mandriva,dc=com"
peopledn="ou=people,%s" % basedn
uris=['ldap://kenobi.mandriva.com','ldap://svn.mandriva.com']
random.shuffle(uris)
uri = " ".join(uris)
timeout=5
binddn="uid=sshkeyreader,ou=System Accounts,%s" % basedn
pwfile="/etc/sshkeyreader.pw"
# filter out disabled accounts also
# too bad uidNumber doesn't support >= filters
filter="(&(objectClass=inetOrgPerson)(objectClass=ldapPublicKey)(objectClass=posixAccount)(sshPublicKey=*)(!(shadowExpire=*)))"
keypathprefix="/var/lib/config/pubkeys"

def usage():
    print "%s" % sys.argv[0]
    print
    print "Will fetch all enabled user accounts under %s" % peopledn
    print "with ssh keys in them and write each one to"
    print "%s/<login>/authorized_keys" % keypathprefix
    print
    print "This script is intented to be run from cron as root"
    print

def get_pw(pwfile):
    try:
        f = open(pwfile, 'r')
    except IOError, e:
        print "Error while reading password file, aborting"
        print e
        sys.exit(1)
    pw = f.readline().strip()
    f.close()
    return pw

def write_keys(keys, user, uid, gid):
    try:
        os.makedirs("%s/%s" % (keypathprefix,user), 0700)
    except:
        pass
    keyfile = "%s/%s/authorized_keys" % (keypathprefix,user)
    f = open(keyfile, 'w')
    for key in keys:
        f.write(key.strip() + "\n")
    f.close()
    os.chmod(keyfile, 0600)
    os.chown(keyfile, uid, gid)
    os.chmod("%s/%s" % (keypathprefix,user), 0700)
    os.chown("%s/%s" % (keypathprefix,user), uid, gid)

if len(sys.argv) != 1:
    usage()
    sys.exit(1)

bindpw = get_pw(pwfile)

try:
    ld = ldap.initialize(uri)
    ld.set_option(ldap.OPT_NETWORK_TIMEOUT, timeout)
    ld.start_tls_s()
    ld.bind_s(binddn, bindpw)
    res = ld.search_s(peopledn, ldap.SCOPE_ONELEVEL, filter, ['uid','sshPublicKey','uidNumber','gidNumber'])
    try:
        os.makedirs(keypathprefix, 0701)
    except:
        pass
    for result in res:
        dn, entry = result
        # skip possible system users
        if int(entry['uidNumber'][0]) < 500:
            continue
        write_keys(entry['sshPublicKey'], entry['uid'][0], int(entry['uidNumber'][0]), int(entry['gidNumber'][0]))
    ld.unbind_s()
except Exception, e:
    print "Error"
    raise

sys.exit(0)


# vim:ts=4:sw=4:et:ai:si
