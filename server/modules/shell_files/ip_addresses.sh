#!/bin/bash
awkCmd=`which awk`
grepCmd=`which grep`
sedCmd=`which sed`
ifconfigCmd=`which ifconfig`
trCmd=`which tr`
digCmd=`which dig`

externalIp=`$digCmd +short myip.opendns.com @resolver1.opendns.com`


output="["

for item in $($ifconfigCmd | $grepCmd -oP "^[a-zA-Z0-9:]*(?=:)")
do 
    output="$output""{\"interface\" : \""$item"\", \"ip\" : \"$( $ifconfigCmd $item | $grepCmd -w "inet" | $awkCmd '{match($0,"inet (addr:)?([0-9.]*)",a)}END{ if (NR != 0){print a[2]; exit}{print "none"}}')\"}, "
done

echo "$output""{ \"interface\": \"external\", \"ip\": \"$externalIp\" } ]"
