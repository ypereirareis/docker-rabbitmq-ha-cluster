# Docker SIRENE data

A way to easily explore the French SIRENE gouv data thanks to Elasticsearch and Kibana.

## Install

```
make install
```


## Indices

```
make console "sirene:index:create sirene01"
make console "sirene:index:index sirene01"
```

## Aliases

```
make console "sirene:index:alias-add sirene01 sirene"
make console "sirene:index:alias-remove sirene01 sirene"
```


## Start application

```
make start
```


## Full indexation

```
make bash
```

PUIS

```
./index.sh sirene01 110 10 # to index 10 millions documents
```

## UIs

* Elasticsearch API : http://127.0.0.1:9200/
* Kibana UI : http://127.0.0.1:5601/
