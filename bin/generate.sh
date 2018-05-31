#!/bin/bash

cd /SackConfig && perl -I. ./sackfigurator && /usr/sbin/rndc -s nsnDNS reload
