#!/bin/bash

cd /home/baydev || exit

function check {

  id=$(cat /home/baydev/id)
  ip=$(/usr/sbin/ifconfig | grep -oP "inet 192(\\.[0-9]+){3}" | grep -oP "192(\\.[0-9]+){3}"|grep 108| head -n1)
  request=https://www.bayerwaldhof.de/guestdisplays.html?screen_target=$id\&ip=$ip
  answer=$(curl -c cookies.txt -b cookies.txt $request)
  url=$(echo $answer | jq .url | sed 's/"//g')
  token=$(echo $answer | jq .update_token | sed 's/"//g')
  rotation=$(echo $answer | jq .rotation | sed 's/"//g')
  scale=$(echo $answer | jq .scale | sed 's/"//g')
  onoff=$(echo $answer | jq .onoff | sed 's/"//g')
  size=$(echo $answer | jq .size | sed 's/"//g')
  csrf=$(echo $answer | jq .csrf | sed 's/"//g')



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
    echo $url > /home/baydev/url
  fi
  if [[ -n "$token" ]]; then
    if [[ $token != $tokenOld ]]; then
      echo $token > /home/baydev/update_token
      sudo service lightdm restart
    fi
  fi

  echo $onoff > /home/baydev/onoff;
  echo $size > /home/baydev/size;
  echo $scale > /home/baydev/scale
  echo $rotation > /home/baydev/rotation
  echo $csrf > /home/baydev/csrf

}

check;
