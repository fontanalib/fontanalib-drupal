#!/bin/sh

apt-get clean
rm -rf /var/lib/apt/lists/* \
       /tmp/scripts \
       /var/tmp/* \
       /var/log/lastlog \
       /var/log/faillog