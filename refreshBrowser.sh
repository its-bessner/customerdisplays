#!/bin/bash

export DISPLAY=:0
xdotool windowactivate $(xdotool search chromium-browser | tail -n1)
xdotool key "ctrl+r"
