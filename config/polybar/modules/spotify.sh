
#!/usr/bin/env sh
ARTIST=$(playerctl metadata xesam:artist) # | sed 's/\b\(.\)/\u\1/g')
TITLE=$(playerctl metadata xesam:title) # | sed 's/\b\(.\)/\u\1/g')

echo "$ARTIST - $TITLE"
