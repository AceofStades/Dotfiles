#!/bin/bash

iDIR="$HOME/.config/swaync/icons"
WebCamIcon="$iDIR/webcam.png"
WebCamOff="$iDIR/webcam-off.png"

if lsmod | grep -q uvcvideo; then
    notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -i "$WebCamOff" "Enter pass to Disable WebCam..."
    pkexec modprobe -r uvcvideo
else
    notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -i "$WebCamIcon" "Enter pass to Enable WebCam..."
    pkexec modprobe uvcvideo
fi
