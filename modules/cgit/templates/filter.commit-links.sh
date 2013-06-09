#!/bin/sh
# This script can be used to generate links in commit messages.
#
# To use this script, refer to this file with either the commit-filter or the
# repo.commit-filter options in cgitrc.
#
# The following environment variables can be used to retrieve the configuration
# of the repository for which this script is called:
# CGIT_REPO_URL        ( = repo.url       setting )
# CGIT_REPO_NAME       ( = repo.name      setting )
# CGIT_REPO_PATH       ( = repo.path      setting )
# CGIT_REPO_OWNER      ( = repo.owner     setting )
# CGIT_REPO_DEFBRANCH  ( = repo.defbranch setting )
# CGIT_REPO_SECTION    ( = section        setting )
# CGIT_REPO_CLONE_URL  ( = repo.clone-url setting )
#

regex=''

# This expression generates links to commits referenced by their SHA1.
regex=$regex'
s|\b([0-9a-fA-F]{7,40})\b|<a href="./?id=\1">\1</a>|g'

# This expression generates links various common bugtrackers.
regex=$regex'
s|mga#([0-9]+)\b|<a href="https://bugs.mageia.org/show_bug.cgi?id=\1">mga#\1</a>|g'
regex=$regex'
s|rhbz#([0-9]+)\b|<a href="https://bugzilla.redhat.com/show_bug.cgi?id=\1">rhbz#\1</a>|g'
regex=$regex'
s|fdo#([0-9]+)\b|<a href="https://bugs.freedesktop.org/show_bug.cgi?id=\1">fdo#\1</a>|g'
regex=$regex'
s|bko#([0-9]+)\b|<a href="https://bugs.kde.org/show_bug.cgi?id=\1">bko#\1</a>|g'
regex=$regex'
s|kde#([0-9]+)\b|<a href="https://bugs.kde.org/show_bug.cgi?id=\1">kde#\1</a>|g'
regex=$regex'
s|bgo#([0-9]+)\b|<a href="https://bugzilla.gnome.org/show_bug.cgi?id=\1">bgo#\1</a>|g'
regex=$regex'
s|gnome#([0-9]+)\b|<a href="https://bugzilla.gnome.org/show_bug.cgi?id=\1">gnome#\1</a>|g'
regex=$regex'
s|lp#([0-9]+)\b|<a href="https://launchpad.net/bugs/\1">lp#\1</a>|g'

sed -re "$regex"
