#!/usr/bin/bash

TMPBG="/tmp/screen.png"

# fast lock with screenshot
scrot $TMPBG
i3lock -i $TMPBG

# gaussian blur
convert $TMPBG -blur 0x7 $TMPBG

if pgrep -a i3lock; then
  killall i3lock
  i3lock -i $TMPBG
fi
