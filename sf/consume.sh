#!/bin/bash
set -e

TYPE=$1
TYPE=${TYPE:-swarrot}

echo "---------------------------------------------------"
echo "> Type: $TYPE"
echo "> Info: 30 consumers running in parallel reading 100 messages each before finishing"
echo "---------------------------------------------------"
echo "30 consumers running..."


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
      { bin/console swarrot:consume:test_consume_quickly swarrot rabbitmq; } &
      { bin/console swarrot:consume:test_consume_quickly swarrot rabbitmq; } &
      { bin/console swarrot:consume:test_consume_quickly swarrot rabbitmq; } &
    fi

    usleep 100000
  done
  wait
  echo "30 new consumers running..."
done
