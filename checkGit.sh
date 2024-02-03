#!/bin/bash
# v119

# usage: checkGit.sh [reboot|batch]
# reboot as first param: restart after apply puppet manifests (this is the default value for cron@reboot)
# batch as first param: apply puppet manifests even if there are no changes from local to remote branch
# No Param at all: just apply the manifest

if [ -n "$(git remote show origin 2>/dev/null | grep 'dev' | grep 'out of date')" ] || [ "$1" = 'batch' ]; then
  git pull origin dev
  sudo puppet apply puppet/base.pp
  sudo puppet apply puppet/config.pp
  if [ "$1" = "reboot" ]; then sudo reboot; fi
else
  sudo puppet apply puppet/base.pp
  sudo puppet apply puppet/config.pp
fi
