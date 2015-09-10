Requirements
============

* Ansible
* Open Zookeeper ports on all servers

```bash
# Zookeeper
sudo lokkit --update -p 2181:tcp
sudo lokkit --update -p 2888:tcp
sudo lokkit --update -p 3888:tcp
# Solr
sudo lokkit --update -p 7574:tcp
sudo lokkit --update -p 8983:tcp
```

Set Up
======

Create Core
-----------

```bash
/opt/solr/bin/solr create -c core1
```

Testing
=======

Open [http://10.100.199.201:8983](http://10.100.199.201:8983) in your favourite browser.


Sample
======

```bash
sudo /opt/solr/bin/solr -e techproducts
```

TODO
====

* Start Zookeeper
* Start solr
* Move ports opening to Ansible