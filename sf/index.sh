#!/bin/bash
set -e

INDEX_NAME=$1
[ -z $INDEX_NAME ] && echo "ERROR - You must define INDEX_NAME as first parameter !!!" && exit 1;

LOOP_ITERATION=$2
[ -z $LOOP_ITERATION ] && echo "ERROR - You must define LOOP_ITERATION as second parameter !!!" && exit 1;


echo "Indexation into '${INDEX_NAME}' with '${LOOP_ITERATION}' iterations"

for j in $(eval echo "{1..$LOOP_ITERATION}")
do

  for i in {1..10}
  do
    { bin/console sirene:index:index "${INDEX_NAME}" -e prod --no-debug; } & # Index 100 000 element
    sleep 1
  done
  wait

  echo "[ $j, $i ] 100 000 Finished !!"
  sleep 1
done

echo "All Finished !!"