#!/bin/bash
# based on https://github.com/metabrainz/docker-exim/blob/master/entrypoint.sh
set -e

# echo "$HOSTNAME" > /etc/mailname

if [[ -n $MYNETWORKS ]]; then
opts=(
  dc_local_interfaces '0.0.0.0 ; ::0'
  dc_other_hostnames ''
  dc_relay_nets "$(ip addr show dev eth0 | awk '$1 == "inet" { print $2 }');${MYNETWORKS}"
)
else
opts=(
  dc_local_interfaces '0.0.0.0 ; ::0'
  dc_other_hostnames ''
  dc_relay_nets "$(ip addr show dev eth0 | awk '$1 == "inet" { print $2 }')"
)
fi

if [ "$GMAIL_USER" -a "$GMAIL_PASSWORD" ]; then
    if [ -n "$PASS_FILE" ]; then
        GMAIL_PASSWORD=$(cat $PASS_FILE)
    fi
  # see https://wiki.debian.org/GmailAndExim4
  opts+=(
    dc_eximconfig_configtype 'smarthost'
    dc_smarthost 'smtp.gmail.com::587'
  )
  echo "*.google.com:$GMAIL_USER:$GMAIL_PASSWORD" > /etc/exim4/passwd.client
  if ! grep 'gpgit.pl' /etc/exim4/exim4.conf.template; then
    sed -i "/^remote_smtp_smarthost:/a      transport_filter = /usr/local/bin/gpgit.pl ${PROTONMAIL_USER}" /etc/exim4/exim4.conf.template
  fi
else
  opts+=(
    dc_eximconfig_configtype 'internet'
  )
fi

set-exim4-update-conf "${opts[@]}"

if [[ -n "$PROTONMAIL_USER_PUBLIC_KEY" ]]; then
  if [ ! -d /var/spool/exim4/.gnupg/ ]; then mkdir -p /var/spool/exim4/.gnupg/; fi
  gpg --homedir /var/spool/exim4/.gnupg/ --import ${PROTONMAIL_USER_PUBLIC_KEY}
  chown Debian-exim /var/spool/exim4/.gnupg/trustdb.gpg
fi

exec "$@"
