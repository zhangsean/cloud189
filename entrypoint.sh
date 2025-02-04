#!/bin/sh
set -e
set -o pipefail

if [ ! -e /bin/cloud189_config.json ]; then
    if [ -n "$CLOUD189_USERNAME" -a -n "$CLOUD189_PASSWORD" ]; then
        cloud189 login -username="$CLOUD189_USERNAME" -password="$CLOUD189_PASSWORD"
    fi

    if [ -n "$CLOUD189_SAVEDIR" -a "$CLOUD189_SAVEDIR" != "/root/Downloads" ]; then
        cloud189 config set -savedir "$CLOUD189_SAVEDIR"
    fi

    if [ -n "$CLOUD189_CACHE_SIZE" ]; then
        cloud189 config set -cache_size "$CLOUD189_CACHE_SIZE"
    fi

    if [ -n "$CLOUD189_PROXY" ]; then
        cloud189 config set -proxy "$CLOUD189_PROXY"
    fi
fi

if [ "$1" == "sh" ]; then
    sh
else
    cloud189 $*
fi