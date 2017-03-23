#!/bin/bash
set -e

while true
do
  for i in {1..20}
  do
    { bin/console swarrot:consume:test_consume_quickly swarrot rabbitmq1; } &
    { bin/console swarrot:consume:test_consume_quickly swarrot rabbitmq1; } &
    { bin/console swarrot:consume:test_consume_quickly swarrot rabbitmq1; } &
    usleep 100000
  done
  wait
done
