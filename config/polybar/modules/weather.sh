#!/bin/env sh
#depends: jq, siji
city="New%20York"
api_key="39214b9803f123f428d81d0e38c1af9c"
lang="en"
unit="imperial"
api="http://api.openweathermap.org/data/2.5/weather"
url="$api?q=$city&lang=$lang&APPID=$api_key&units=$unit"

weather=$(curl -s $url | jq -r '. | "\(.weather[].main)"')
temp=$(curl -s $url | jq -r '. | "\(.main.temp)"' | cut -d"." -f1)
icons=$(curl -s $url | jq -r '. | "\(.weather[].icon)"')

case $icons in
        01d) icon="";;
        01n) icon="";;
        02d) icon="";;
        02n) icon="";;
        03*) icon="";;
        04*) icon="";;
        09d) icon="";;
        09n) icon="";;
        10d) icon="";;
        10n) icon="";;
        11d) icon="";;
        11n) icon="";;
        13d) icon="";;
        13n) icon="";;
        50d) icon="";;
        50n) icon="";;
        *) icon="";
esac

echo $icon $temp"°F"
