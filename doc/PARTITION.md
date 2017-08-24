# Tests/Benckmark

## Network partition

![Rabbit cluster](./../img/rabbitmq_netpart.png)

### Exclude node 1 from the network cluster

```
$ make exclude-node-1
== Exclude rabbitmq node 1 from cluster ==
```

### Restore node 1 in the network cluster

```
$ make restore-node-1 
== Exclude rabbit node 1 from cluster ==
```

**Partition between node 1 and node 2 and 3...**

![Rabbit cluster](./../img/rabbit-netpart-1.png)


![Rabbit cluster](./../img/rabbit-netpart-2.png)

**...but all nodes are still running**

![Rabbit cluster](./../img/rabbitmq-netpart-ctop.png)


[https://www.rabbitmq.com/partitions.html](https://www.rabbitmq.com/partitions.html)

[Go to Index](../README.md#documentation)  

[Setup](./SETUP.md)  
[Swarrot/SwarrotBundle](./SWARROT.md)  
[OldSound/RabbitMqBundle](./OLDSOUND.md)  
[Node failures](./FAILURE.md)  
[Network partition](./PARTITION.md)  
[Big cluster](./BIG.md)  
