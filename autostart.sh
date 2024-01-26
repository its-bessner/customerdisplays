#!/bin/bash
# exit 0;

# Force a delay of at least 60 seconds
#secondsSinceBoot=$(($(date +%s) - $( date -d "$(who -b | awk '{print $2,$3}')" +%s )))
#if [ $secondsSinceBoot -lt 60 ]; then
#     exit 0
#fi
export DISPLAY=:0

function preventScreenBlanking {
  xset -dpms
  xset s off
  xset s noblank
}

function setRotation {
  xrandr --output HDMI-1 --rotate "$(cat /home/baydev/rotation)"
}

function setScale {

  xrandr --output HDMI-1 --scale "$(cat /home/baydev/scale)"
}

function setSize {
  if [ -n "$(cat /home/baydev/size)" ]; then
    xrandr -s "$(cat /home/baydev/size)"
  fi

}

function setOnOff {
  if [ "$(cat /home/baydev/onoff)" = "off" ]; then
   echo standby 0.0.0.0 | cec-client -s -d 1
   xrandr --output HDMI-1 --off
  else
    echo on 0.0.0.0 | cec-client -s -d 1
    xrandr --output HDMI-1 --auto
  fi
}

function check {

  ## Chromium not running? Start it!
  if [ "$(ps aux | grep chromium-browser | wc -l)" -lt "2" ]; then
    unclutter &
    chromium-browser "$(cat /home/baydev/url)" \
      --start-fullscreen \
      --kiosk \
      --incognito \
      --noerrdialogs \
      --disable-translate \
      --no-first-run \
      --fast \
      --fast-start \
      --disable-infobars \
      --disable-features=TranslateUI \
      --disk-cache-dir=/dev/null \
      --overscroll-history-navigation=0 \
      --disable-pinch &
    disown
  fi

}

# Here we go!
preventScreenBlanking &
setOnOff &
setRotation &
setSize &
setScale &
check &

# Change 004


