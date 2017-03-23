#!/bin/bash
set -e

while true
do
  for i in {1..10}
  do
    { bin/console rb:test; } &
    usleep 100000
  done
  wait
done
