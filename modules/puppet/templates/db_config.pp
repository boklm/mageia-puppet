<%- if database == 'sqlite3' -%>
    dbadapter = sqlite3
    dblocation = /var/lib/puppet/storeconfigs.db
<%- else -%>
    dbadapter = postgresql
    dbuser = puppet
    dbpassword = <%= pgsql_password %>
    dbserver = pgsql.<%= domain %>
    dbname = puppet
<%- end -%>
