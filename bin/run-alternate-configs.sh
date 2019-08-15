#!/bin/bash

cd /SackConfig
for f in sack.conf.d/*.conf
do
  LOCALNAME=$(grep ^localname /SackConfig/${f} | awk '{ print $NF }')
  echo "Localname is $LOCALNAME"
  LOCALCONF=$(echo $LOCALNAME | sed 's/\.nameserver.net/.conf/')
  if [ ! -e /SackConfig/$LOCALCONF ]; then
    echo "Linking $LOCALCONF from webdir"
    ln -s /usr/share/nginx/html/$LOCALCONF /SackConfig/$LOCALCONF
  fi

  perl -I. ./sackfigurator ${f}
done