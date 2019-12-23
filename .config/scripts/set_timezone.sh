#!/bin/sh
apk add --update --no-cache tzdata
TZ=$1
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone