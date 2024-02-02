#!/bin/bash
# v106

git fetch origin master
if [ -n "$(git diff origin/master)" ] || [ "$1" = "batch" ]; then
  git pull origin master
  sudo puppet apply puppet/base.pp
  sudo puppet apply puppet/config.pp
  if [ "$1" = "#reboot" ]; then sudo reboot; fi
fi