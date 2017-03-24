#!/bin/bash
set -e

TYPE=$1

echo "---------------------------------------------------"
echo "Type : $TYPE"
echo "---------------------------------------------------"


while true
do
  for i in {1..10}
  do
    if [ "$TYPE" == "oldsound" ]
    then
      { bin/console rb:oldsound; } &
    else
      { bin/console rb:test; } &
    fi
    usleep 100000
  done
  wait
done
