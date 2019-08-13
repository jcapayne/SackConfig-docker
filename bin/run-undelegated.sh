#!/bin/sh

TMPFILE=/tmp/$$
OUTFILE=/usr/share/nginx/html/undelegated.html

cd /SackConfig

./undelegated > ${TMPFILE}

if [ $(wc -l < ${TMPFILE}) -gt 2 ]
  then mv ${TMPFILE} ${OUTFILE}
fi
