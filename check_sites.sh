#!/bin/bash

set -e

FILE="`pwd`/WEBSITES"
CURL="$(which curl)"

if [[ ! -f $FILE ]]; then
  echo "Cannot find $FILE."
  exit 1
fi

if [[ ${#CURL} -eq 0 ]]; then
    echo "Install curl first."
    exit 1
fi

handle_sigint() {
  set +e
  for job in `jobs -p`
  do
      kill -9 $job >/dev/null 2>&1
  done
  set -e
  echo "Aborted by user. Goodbye!"
  exit
}

trap handle_sigint SIGINT

OLD_IFS=$IFS
IFS=$'\n'
WEBSITES=($(cat $FILE))
IFS=$OLD_IFS

for (( i = 0; i < "${#WEBSITES[@]}"; i++ )); do
  $CURL -m 10 -s -L -I -o /dev/null \
  -w "time = %{time_total}\tstatus = %{http_code}\tip = %{remote_ip}\thttp://www.${WEBSITES[$i]}/\n" \
  "http://www.${WEBSITES[$i]}" &
done

wait

exit 0
