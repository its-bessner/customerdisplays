#!/bin/bash
# v101

git fetch origin master
if [ -n "$(git diff origin/master)" ]; then
  git pull origin master
  sudo puppet apply puppet/config.pp
  if [ -n "$1" ]; then sudo reboot; fi
fi