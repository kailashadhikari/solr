Requirements
============

* Ansible
* VirtualBox
* Vagrant

```bash
vagrant plugin install vagrant-proxyconf
```

Set Up
======

```bash
export http_proxy=http://10.110.8.42:8080
export https_proxy=http://10.110.8.42:8080
export VAGRANT_HTTP_PROXY="$http_proxy"
export VAGRANT_HTTPS_PROXY="$https_proxy"

vagrant up
```

Solr
====

```bash
# sudo service solr [start|stop|status|restart]

COLLECTION=coll7
SHARDS=2
REPLICATION_FACTOR=1
sudo /opt/solr/bin/solr create_collection \
    -c $COLLECTION \
    -shards $SHARDS \
    -replicationFactor $REPLICATION_FACTOR
```

Zookeeper
=========

```bash
/opt/zookeeper/bin/zkCli.sh -server 127.0.0.1:2181
create /zk_test my_data
ls /
get /live_nodes
```

Testing
=======

Open [http://10.100.199.201:8983](http://10.100.199.201:8983) in your favourite browser.

Git Proxy
=========

```bash
git config --global http.proxy $http_proxy
```