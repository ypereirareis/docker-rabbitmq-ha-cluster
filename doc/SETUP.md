# Setup / Start / Stop the cluster

```shell
git clone git@github.com:ypereirareis/docker-rabbitmq-ha-cluster.git && cd docker-rabbitmq-ha-cluster
make install
make start
make stop
```

:broken_heart: **Do not set container names manually or the auto configuration of HAProxy will not work anymore.**   
:green_heart: You can change the `docker-compose -p` option (project variable) in [Makefile](../Makefile), but you will need to update some `make` targets:

* https://github.com/ypereirareis/docker-rabbitmq-ha-cluster/blob/master/Makefile#L19-L23
* https://github.com/ypereirareis/docker-rabbitmq-ha-cluster/blob/master/Makefile#L66-L98

Once the setup process is over, check everything is ok (sometimes the startup process fails):

```
make stop && make start # To restart the cluster properly
```

```shell
$ make state
== Print state of containers ==
    Name                   Command               State                                                          Ports                                                         
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rmq_haproxy_1   /sbin/tini -- dockercloud- ...   Up      1936/tcp, 443/tcp, 0.0.0.0:5672->5672/tcp, 0.0.0.0:80->80/tcp                                                        
rmq_rmq1_1      /pre-entrypoint.sh rabbitm ...   Up      127.0.0.1:1234->15672/tcp, 25672/tcp, 4369/tcp, 5672/tcp, 9100/tcp, 9101/tcp, 9102/tcp, 9103/tcp, 9104/tcp, 9105/tcp 
rmq_rmq2_1      /pre-entrypoint.sh rabbitm ...   Up      127.0.0.1:1235->15672/tcp, 25672/tcp, 4369/tcp, 5672/tcp, 9100/tcp, 9101/tcp, 9102/tcp, 9103/tcp, 9104/tcp, 9105/tcp 
rmq_rmq3_1      /pre-entrypoint.sh rabbitm ...   Up      127.0.0.1:1236->15672/tcp, 25672/tcp, 4369/tcp, 5672/tcp, 9100/tcp, 9101/tcp, 9102/tcp, 9103/tcp, 9104/tcp, 9105/tcp
```

![Rabbit cluster](./../img/ctop_start.png)

Access the Management Plugin interface for nodes:

* http://127.0.0.1:1234
* http://127.0.0.1:1235
* http://127.0.0.1:1236

![Rabbit cluster](./../img/rabbitmq_cluster_start.png)

You can use, test or compare two php/symfony librairies.
Simply use one of the library or both in the mean time.

[Go to Index](../README.md)
