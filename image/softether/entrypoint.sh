#!/usr/bin/env bash
set -xe

date -R >> /log.txt
echo $SHLVL >> /log.txt
bash -c "$@"
