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

    if [ "$TYPE" = "oldsound" ]
    then
      { bin/console rabbitmq:consumer oldsound -m 100; } &
      { bin/console rabbitmq:consumer oldsound -m 100; } &
      { bin/console rabbitmq:consumer oldsound -m 100; } &
    else
      { bin/console swarrot:consume:test_consume_quickly swarrot rabbitmq1; } &
      { bin/console swarrot:consume:test_consume_quickly swarrot rabbitmq1; } &
      { bin/console swarrot:consume:test_consume_quickly swarrot rabbitmq1; } &
    fi

    usleep 100000
  done
  wait
done
