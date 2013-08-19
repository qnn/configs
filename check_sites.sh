#!/bin/bash

set -e

CURL="$(which curl)"

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
WEBSITES=($(ls -1 configs | sed 's/.yml$//'))
IFS=$OLD_IFS

for (( i = 0; i < "${#WEBSITES[@]}"; i++ )); do
  $CURL -m 10 -s -L -I -o /dev/null 2>/dev/null \
  -w "time = %{time_total}\tstatus = %{http_code}\tip = %{remote_ip}\thttp://www.${WEBSITES[$i]}/\n" \
  "http://www.${WEBSITES[$i]}" &
done

wait

exit 0
