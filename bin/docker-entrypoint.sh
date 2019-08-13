#!/bin/bash


if [ "$1" == '/bin/bash' ]; then
  exec "$@"
fi


if [ -z $NSN_SERVICE ]; then
  echo "SET THE NSN_SERVICE ENVIRONMENT VARIABLE"
  exit 1
fi

if [ "$NSN_SERVICE" = "web" ]; then
  /usr/sbin/nginx
elif [ "$NSN_SERVICE" = "cron" ]; then
  LOCALNAME=$(grep ^localname /SackConfig/sack.conf | awk '{ print $NF }')
  echo "Localname is $LOCALNAME"
  LOCALCONF=$(echo $LOCALNAME | sed 's/\.nameserver.net/.conf/')
  if [ ! -e /SackConfig/$LOCALCONF ]; then
    echo "Linking $LOCALCONF from webdir"
    ln -s /usr/share/nginx/html/$LOCALCONF /SackConfig/$LOCALCONF
  fi
  echo "Generating sackdns.conf"
  /SackConfig/generate.sh
  /usr/sbin/cron -f && tail -f /var/log/cron.log
elif [ "$NSN_SERVICE" = "dns" ]; then
  if [ ! -e /etc/bind/sackdns.conf ]; then
    touch /etc/bind/sackdns.conf
  fi
  /usr/sbin/named-checkconf -z
  /usr/sbin/named -u bind -f
else
  echo "UNKNOWN SERVICE $NSN_SERVICE"
  exit 1
fi
