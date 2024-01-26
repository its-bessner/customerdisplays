#!/bin/bash

git fetch origin master
if [ -n "$(git diff origin/master)" ]; then
  git pull
  sudo puppet apply puppet/config.pp
fi
