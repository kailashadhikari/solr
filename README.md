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

Zookeeper
=========

```bash
/opt/zookeeper/bin/zkCli.sh -server 127.0.0.1:2181
create /zk_test my_data
ls /
get /zk_test
set /zk_test junk
get /zk_test
```

Solr
====

```bash
### Create core

sudo /opt/solr/bin/solr create -c core1

### Add a document

sudo /opt/solr/bin/post -c gettingstarted example/exampledocs/*.xml

### Search

http://localhost:8983/solr/gettingstarted/select?q=video

http://localhost:8983/solr/gettingstarted/select?q=video&fl=id,name,price

http://localhost:8983/solr/gettingstarted/select?q=name:black

http://localhost:8983/solr/gettingstarted/select?q=price:[0%20TO%20400]&fl=id,name,price

### Start in cloud mode with external Zookeeper

sudo /opt/solr/bin/solr start \
    -c \
    -z 10.100.199.201:2181,10.100.199.202:2181,10.100.199.203:2181

### Restart in cloud mode with external Zookeeper

sudo /opt/solr/bin/solr restart \
    -c \
    -z 10.100.199.201:2181,10.100.199.202:2181,10.100.199.203:2181

### Stop

sudo /opt/solr/bin/solr stop

### Status

sudo /opt/solr/bin/solr status

### Health

sudo /opt/solr/bin/solr healthcheck \
    -c core1 \
    -rf 3 \
    -z 10.100.199.201:2181,10.100.199.202:2181,10.100.199.203:2181

### Delete

sudo /opt/solr/bin/solr delete \
    -c core1
```

Testing
=======

Open [http://10.100.199.201:8983](http://10.100.199.201:8983) in your favourite browser.

Git Proxy
=========

```bash
git config --global http.proxy $http_proxy
```

Questions
=========

* Cloud option (-c) is not set in the installation instructions?
* Are we using sharding, replication, both or none?


TODO
====

```bash
sudo /opt/solr/bin/solr stop -all

sudo /opt/solr/bin/solr start \
    -c \
    -z 10.100.199.201:2181,10.100.199.202:2181,10.100.199.203:2181

sudo /opt/solr/bin/solr create -c viktor1 -rf 2
# solr create -c master -d sample_techproducts_configs -p 8983 -rf 3
# http://examples.javacodegeeks.com/enterprise-java/apache-solr/apache-solr-replication-example/
```