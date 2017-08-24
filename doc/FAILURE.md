# Tests/Benckmark

## Node failures

### Stop the first node

```
$ make stop-node-1
== Stop rabbitmq node 1 from cluster ==
rmq_rmq1_1
```

![Rabbit cluster](./../img/rabbitmq-node1-stop.png)

### Stop the second node

```
$ make stop-node-2 
== Stop rabbitmq node 2 from cluster ==
rmq_rmq2_1
```

![Rabbit cluster](./../img/rabbitmq-node2-stop.png)

### Restart the first node

```
$ make resume-node-1
== Stop rabbitmq node 1 from cluster ==
rmq_rmq1_1
```

![Rabbit cluster](./../img/rabbitmq-node1-restart.png)

### Restart all nodes

```
$ make start
== Start App ==
rmq_rmq1_1 is up-to-date
Starting rmq_rmq2_1
Starting rmq_rmq3_1
rmq_haproxy_1 is up-to-date
```

![Rabbit cluster](./../img/rabbitmq-all-restart.png)

[Go to Index](../README.md#documentation)  

[Setup](./SETUP.md)  
[Swarrot/SwarrotBundle](./SWARROT.md)  
[OldSound/RabbitMqBundle](./OLDSOUND.md)  
[Node failures](./FAILURE.md)  
[Network partition](./PARTITION.md)  
[Big cluster](./BIG.md)  
