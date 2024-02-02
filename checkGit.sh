#!/bin/bash
# v118

# usage: checkGit.sh [reboot|batch]
# reboot as first param: restart after apply puppet manifests (this is the default value for cron@reboot)
# batch as first param: apply puppet manifests even if there are no changes from local to remote branch

if [ -n "$(git remote show origin 2>/dev/null | grep 'master' | grep 'out of date')" ] || [ "$1" = 'batch' ]; then
  git pull origin master
  sudo puppet apply puppet/base.pp
  sudo puppet apply puppet/config.pp
  if [ "$1" = "reboot" ]; then sudo reboot; fi
fi
