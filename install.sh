#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="nginx"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 020920211905-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.pro
# @License       : LICENSE.md
# @ReadME        : README.md
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Tuesday, Feb 09, 2021 19:05 EST
# @File          : nginx
# @Description   : Installer script for nginx
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/main/functions}"
connect_test() { ping -c1 1.1.1.1 &>/dev/null || curl --disable -LSs --connect-timeout 3 --retry 0 --max-time 1 1.1.1.1 2>/dev/null | grep -e "HTTP/[0123456789]" | grep -q "200" -n1 &>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
elif connect_test; then
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the main function
system_installdirs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Make sure the scripts repo is installed
scripts_check
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults
APPNAME="${APPNAME:-nginx}"
APPDIR="/usr/local/etc/$APPNAME"
INSTDIR="$SYSSHARE/CasjaysDev/systemmgr/$APPNAME"
REPO_BRANCH="${GIT_REPO_BRANCH:-main}"
REPO="${SYSTEMMGRREPO:-https://github.com/systemmgr}/$APPNAME"
REPORAW="$REPO/raw/$REPO_BRANCH"
APPVERSION="$(__appversion "$REPORAW/version.txt")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup plugins
PLUGNAMES=""
PLUGDIR="${SHARE:-$HOME/.local/share}/$APPNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Require a version higher than
systemmgr_req_version "$APPVERSION"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the systemmgr function
systemmgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script options IE: --help
show_optvars "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Requires root - no point in continuing
sudoreq # sudo required
#sudorun # sudo optional
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Do not update - add --force to overwrite
#installer_noupdate "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# initialize the installer
systemmgr_run_init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end with a space
APP="$APPNAME "
PERL=""
PYTH=""
PIPS=""
CPAN=""
GEMS=""

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# install packages - useful for package that have the same name on all oses
install_packages "$APP"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# install required packages using file
install_required "$APP"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check for perl modules and install using system package manager
install_perl "$PERL"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check for python modules and install using system package manager
install_python "$PYTH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check for pip binaries and install using python package manager
install_pip "$PIPS"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check for cpan binaries and install using perl package manager
install_cpan "$CPAN"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# check for ruby binaries and install using ruby package manager
install_gem "$GEMS"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Other dependencies
dotfilesreq
dotfilesreqadmin
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure directories exist
ensure_dirs
ensure_perms
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Backup if needed
if [ -d "$APPDIR" ]; then
  execute "backupapp $APPDIR $APPNAME" "Backing up $APPDIR"
fi
# Main progam
if am_i_online; then
  if [ -d "$INSTDIR/.git" ]; then
    execute "git_update $INSTDIR" "Updating $APPNAME configurations"
  else
    execute "git_clone $REPO $INSTDIR" "Installing $APPNAME configurations"
  fi
  # exit on fail
  failexitcode $? "Git has failed"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
# shellcheck disable=SC2317
run_postinst() {
  systemmgr_run_post
  ipaddr="${CURRENT_IP_4:-127.0.0.0.1}"
  hostname="$(hostname -f 2>/dev/null)"
  apache_bin="$(type -P httpd || type -p "apache2" || type -P apachectl || false)"
  __type() { type -P "$1" 2>/dev/null; }
  __get_www_user() {
    local user=""
    user="$(grep -sh "www-data" "/etc/passwd" || grep -sh "apache" "/etc/passwd" || grep -sh "nginx" "/etc/passwd")"
    [ -n "$user" ] && echo "$user" | awk -F ':' '{print $1}' || return 9
  }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  __get_www_group() {
    local group=""
    group="$(grep -sh "www-data" "/etc/group" || grep -sh "apache" "/etc/group" || grep -sh "nginx" "/etc/group")"
    [ -n "$group" ] && echo "$group" | awk -F ':' '{print $1}' || return 9
  }
  GET_WEB_USER="$(__get_www_user)"
  GET_WEB_GROUP="$(__get_www_group)"
  cp_rf "$APPDIR"/. "/etc/nginx/"
  if_os_id arch && sed -i "s|^pid    |#pid    |g" "/etc/nginx/nginx.conf"
  if_os_id arch && sed -i "s|^user.*apache|#user  http|g" "/etc/nginx/nginx.conf"
  if_os_id debian && sed -i "s|^user.*apache|user  www-data|g" "/etc/nginx/nginx.conf"
  sed_replace myserverip "${ipaddr// /}" "/etc/nginx/conf.d/default.conf"
  sed_replace myserverdomainname "$hostname" "/etc/nginx/nginx.conf"
  sed_replace myserverdomainname "$hostname" "/etc/nginx/vhosts.d/0000-default.conf"
  cmd_exists changeip && changeip &>/dev/null
  if [ -z "$(__type transmission || __type transmission-daemon || __type transmission-gtk)" ]; then
    sed -i "/transmission.conf/d" '/etc/nginx/vhosts.d'/* 2>/dev/null
    [ -f "/etc/nginx/global.d/transmission.conf" ] && rm -Rf "/etc/nginx/global.d/transmission.conf"
  fi
  if [ -z "$apache_bin" ]; then
    [ -f "/etc/nginx/vhosts.d/0000-default.conf" ] && rm -Rf "/etc/nginx/vhosts.d/0000-default.conf"
    for f in apache-defaults.conf cgi-bin.conf munin.conf others.conf vnstats.conf; do
      [ -f "/etc/nginx/global.d/$f" ] && rm -Rf "/etc/nginx/global.d/$f"
      sed -i "/$f/d" "/etc/nginx.conf" 2>/dev/null
      sed -i "/$f/d" "/etc/nginx/vhosts.d"/* 2>/dev/null
    done
  fi
  if [ -n "$GET_WEB_USER" ]; then
    if [ -f "/etc/nginx/nginx.conf" ]; then
      sed -i '0,/^user .*/s//user  '$GET_WEB_USER';/' "/etc/nginx/nginx.conf"
      grep -sqh "^user  $GET_WEB_USER" "/etc/nginx/nginx.conf" || echo "Failed to change the user in /etc/nginx/nginx.conf"
    fi
    if [ -f "/etc/php-fpm.d/www.conf" ]; then
      sed -i '0,/^user .*/s//user = '$GET_WEB_USER'/' "/etc/php-fpm.d/www.conf"
      grep -sqh "^user = $GET_WEB_USER" "/etc/php-fpm.d/www.conf" || echo "Failed to change the user in /etc/php-fpm.d/www.conf"
    fi
    if [ -f "/etc/httpd/conf/httpd.conf" ]; then
      sed -i '0,/^User .*/s//User '$GET_WEB_USER'/' "/etc/httpd/conf/httpd.conf"
      grep -sqh "^User $GET_WEB_USER" "/etc/httpd/conf/httpd.conf" || echo "Failed to change the user in /etc/httpd/conf/httpd.conf"
    fi
    for apache_dir in "/usr/local/share/httpd" "/var/www"; do
      [ -d "$apache_dir" ] && chown -Rf $GET_WEB_USER "$apache_dir"
    done
  fi
  if [ -n "$GET_WEB_GROUP" ]; then
    if [ -f "/etc/php-fpm.d/www.conf" ]; then
      sed -i '0,/^group .*/s//group = '$GET_WEB_GROUP'/' "/etc/php-fpm.d/www.conf"
      grep -sqh "^group = $GET_WEB_GROUP" "/etc/php-fpm.d/www.conf" || echo "Failed to change the group in /etc/php-fpm.d/www.conf"
    fi
    if [ -f "/etc/httpd/conf/httpd.conf" ]; then
      sed -i '0,/^Group .*/s//Group '$GET_WEB_GROUP'/' "/etc/httpd/conf/httpd.conf"
      grep -sqh "^Group $GET_WEB_GROUP" "/etc/httpd/conf/httpd.conf" || echo "Failed to change the group in /etc/httpd/conf/httpd.conf"
    fi
    for apache_dir in "/usr/local/share/httpd" "/var/www"; do
      [ -d "$apache_dir" ] && chgrp -Rf $GET_WEB_GROUP "$apache_dir"
    done
  fi
  systemctl enable --now nginx >/dev/null && systemctl restart nginx >/dev/null
}
#
execute "run_postinst" "Running post install scripts"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create version file
systemmgr_install_version
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run exit function
run_exit
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
