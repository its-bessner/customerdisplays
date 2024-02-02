#!/bin/bash
# v115

if [ -n "$(git remote show origin 2>/dev/null | grep 'master' | grep 'out of date')" ] || [ "$1" = 'batch' ]; then
  git pull origin master
  sudo puppet apply puppet/base.pp
  sudo puppet apply puppet/config.pp
  if [ "$1" = "reboot" ]; then sudo reboot; fi
fi
