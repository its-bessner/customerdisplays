#!/bin/bash

cd /home/baydev || exit

function isOnOff {
  timespan="$1"
  if [ "$timespan" == "always" ]; then
    echo on
  elif [ "$timespan" == "never" ]; then
    echo off
  else
    timespan=${timespan// /}
    IFS='-' read -ra TIMES <<<"$timespan"
    begin=${TIMES[0]//:/}
    end=${TIMES[1]//:/}
    current=$(date +%H%M)
    begin=$((10#$begin))
    current=$((10#$current))
    end=$((10#$end))
    ((current >= begin && current <= end)) && echo on || echo off
  fi
}

function check {

  id=$(cat /home/baydev/id)
  ip=$(/usr/sbin/ifconfig | grep -Po "^\s+inet \K192\.\d+\.\d+\.\d+" | paste -s -d "+")
  request=https://www.bayerwaldhof.de/guestdisplays.html?screen_target=$id\&ip=$ip
  answer=$(curl -L -c cookies.txt -b cookies.txt $request)
  url=$(echo $answer | jq .url | sed 's/"//g')
  token=$(echo $answer | jq .update_token | sed 's/"//g')
  rotation=$(echo $answer | jq .rotation | sed 's/"//g')
  scale=$(echo $answer | jq .scale | sed 's/"//g')
  onoff=$(echo $answer | jq .onoff | sed 's/"//g')
  onoff=$(isOnOff "$onoff")
  echo "onoff: $onoff";
  size=$(echo $answer | jq .size | sed 's/"//g')
  csrf=$(echo $answer | jq .csrf | sed 's/"//g')


   // Bail out if the URL can't be parsed
   if [ -z "$url" ]; then
    exit -1
   fi

  tokenOld=$(cat /home/baydev/update_token)
  echo "-----------------------------"
  echo $id
  echo $ip
  echo $answer
  echo $url
  echo $token
  echo $tokenOld
  echo $rotation
  echo $scale
  echo $size
  echo $onoff
  echo $csrf
  echo "-----------------------------"
  if [[ -n "$url" ]]; then
    echo $url >/home/baydev/url
  fi
  if [[ -n "$token" ]]; then
    if [[ $token != $tokenOld ]]; then
      echo $token >/home/baydev/update_token
      if [[ "$token" =~ "restart" ]]; then
        sudo reboot
      elif [[ "$token" =~ "reload" ]]; then
        su baydev /home/baydev/refreshBrowser.sh
      elif [[ "$token" =~ "pull" ]]; then
        cd /home/baydev && su baydev gitPull.sh
      else
        sudo service lightdm restart
      fi
    fi
  fi

  if [ -f /home/baydev/forceOff ]; then
    onoff=off
  elif [ -f /home/baydev/forceOn ]; then
    onoff=on
  fi
  echo $onoff >/home/baydev/onoff

  echo $size >/home/baydev/size
  echo $scale >/home/baydev/scale
  echo $rotation >/home/baydev/rotation
  echo $csrf >/home/baydev/csrf

}

check
