#!/bin/bash
# v107

git fetch origin dev
if [ -n "$(git diff origin/dev)" ] || [ "$1" = "batch" ]; then
  git pull origin dev
  sudo puppet apply puppet/base.pp
  sudo puppet apply puppet/config.pp
  if [ "$1" = "reboot" ]; then sudo reboot; fi
fi
