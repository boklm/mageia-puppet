#!/bin/bash
export FCGI_SOCKET_PATH=/tmp/gitweb.socket

/usr/share/gitweb/gitweb.cgi --fastcgi

