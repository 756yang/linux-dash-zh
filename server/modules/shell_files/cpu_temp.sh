#!/bin/bash
if [ `which sensors` ]; then
  returnString=`sensors`
  #amd
  if [[ "${returnString/"k10"}" != "${returnString}" ]] ; then
    echo ${returnString##*k10} | cut -d ' ' -f 6 | cut -c 2-5
  #intel
  elif [[ "${returnString/"coretemp"}" != "${returnString}" ]] ; then
    fromcore="$(echo "${returnString##*coretemp}" | grep -B1 Core)"
    # some platform not have 'Physical', don't use `echo ${fromcore##*Physical}`
    echo ${fromcore#* } | cut -d ' ' -f 3 | cut -c 2-5
  else
    echo "[]"
  fi
else
  echo "[]"
fi

