#!/bin/bash

cd /SackConfig
for f in sack.conf.d/*.conf
do
  perl -I. ./sackfigurator ${f}
done