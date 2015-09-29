Requirements
============

* Ansible (only if setup is automated)
* VirtualBox (only if development VMs are created)
* Vagrant (only if development VMs are created)

```bash
vagrant plugin install vagrant-proxyconf
vagrant plugin install vagrant-cachier
```

Setting Up Solr
===============

Creating development VMs
------------------------

```bash
export http_proxy=http://10.110.8.42:8080
export https_proxy=http://10.110.8.42:8080
export VAGRANT_HTTP_PROXY="$http_proxy"
export VAGRANT_HTTPS_PROXY="$https_proxy"

vagrant up
```

Automatic Set Up
----------------

```bash
# The name of the inventory file
INVENTORY=dev

ansible-playbook ansible/solr.yml -i ansible/hosts/$INVENTORY
```

Manually Setting Up Zookeeper
-----------------------------

The following procedure should be repeated on every server solr should be running on.

```bash
# Directory where this source code is located
SOURCE_CODE_DIR=/vagrant

# Download the distribution
wget \
    http://apache.rediris.es/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz \
    -O /opt/zookeeper-3.4.6.tar.gz

# Unpacak the distribution
cd opt
tar -xzvf zookeeper-3.4.6.tar.gz

# Create the product link
ln -s /opt/zookeeper-3.4.6 /opt/zookeeper

# Create directories
sudo mkdir -p /var/zookeeper/{log,data}

# Create the service script
sudo cp \
    $SOURCE_CODE_DIR/ansible/roles/zookeeper/files/zkinit.sh \
    /etc/init.d/zookeeper
sudo chmod 755 /etc/init.d/zookeeper

# Copy config files
# Manually modify the file by putting all zookeeper hosts
sudo cp \
    $SOURCE_CODE_DIR/ansible/roles/zookeeper/templates/zoo.cfg \
    /opt/zookeeper/conf/zoo.cfg
# Manually modify the file by putting an incremental ID starting from 1
sudo cp \
    $SOURCE_CODE_DIR/ansible/roles/zookeeper/templates/myid \
    /var/zookeeper/data/myid

# Start the service
sudo service zookeeper start
```

Manually Setting Up solr
------------------------

The following procedure should be repeated on every server solr should be running on.

```bash
# Directory where this source code is located
SOURCE_CODE_DIR=/vagrant

# Download the distribution
wget \
    http://archive.apache.org/dist/lucene/solr/5.2.1/solr-5.2.1.tgz \
    -O /opt/solr-5.2.1.tgz

# Unpacak the distribution
cd opt
tar -xzvf solr-5.2.1.tgz

# Create the service script
sudo cp \
    $SOURCE_CODE_DIR/ansible/roles/solr/solrinit.sh \
    /etc/init.d/solr
sudo chmod 755 /etc/init.d/solr

# Create the product link
ln -s /opt/solr-5.2.1 /opt/solr

# Copy the configuration executable
# Manually modify the following file with the Zookeeper information:
# $SOURCE_CODE_DIR/ansible/roles/solr/templates/solr.in.sh
sudo cp \
    $SOURCE_CODE_DIR/ansible/roles/solr/templates/solr.in.sh \
    /opt/solr/bin/solr.in.sh

# Start the service
sudo service solr start
```

Automatically Creating Collections
----------------------------------

```bash
# Directory where this source code is located
SOURCE_CODE_DIR=/vagrant
# The name of the inventory file
INVENTORY=dev

# Run the playbook
ansible-playbook \
    $SOURCE_CODE_DIR/ansible/solr-collection.yml \
    -i $SOURCE_CODE_DIR/ansible/hosts/$INVENTORY
```

Manually Creating Collections
------------------------------------------

```bash
# The name of the collection that should be created
COLLECTION=employees
# The number of shards that should be used
SHARDS=2
# Replication factor
REPLICATION_FACTOR=2
# Directory where this source code is located
SOURCE_CODE_DIR=/vagrant

# Create directories
sudo mkdir -p /opt/solr/contrib/dataimporthandler/lib
sudo mkdir -p /opt/solr/server/solr/configsets/$COLLECTION/conf
sudo mkdir -p /opt/solr/server/solr/configsets/$COLLECTION/conf/lang
sudo mkdir -p /opt/solr/server/solr/configsets/$COLLECTION/data

# Manually modify the following files with the information about the data source that is to be imported:
# $SOURCE_CODE_DIR/ansible/roles/solr-collection/files/data-config.xml
# $SOURCE_CODE_DIR/ansible/roles/solr-collection/files/schema.xml
# $SOURCE_CODE_DIR/ansible/roles/solr-collection/files/sqlconfig.xml

# Copy configurations
sudo cp -R \
    $SOURCE_CODE_DIR/ansible/roles/solr-collection/files/* \
    /opt/solr/server/solr/configsets/$COLLECTION

# Create collection
sudo /opt/solr/bin/solr create_collection \
    -c $COLLECTION \
    -shards $SHARDS \
    -replicationFactor $REPLICATION_FACTOR \
    -d /opt/solr/server/solr/configsets/$COLLECTION/conf
```

Manually Deleting Collections
-----------------------------

```bash
COLLECTION=employees

sudo /opt/solr/bin/solr delete  -c $COLLECTION
```

Misc
====

Zookeeper CLI
-------------

```bash
/opt/zookeeper/bin/zkCli.sh -server 127.0.0.1:2181
create /zk_test my_data
ls /
get /live_nodes
```

solr UI
-------

Open [http://10.100.199.201:8983](http://10.100.199.201:8983) in your favourite browser.

Git Proxy
---------

```bash
git config --global http.proxy $http_proxy
```

MySql
-----

```bash
# Start the mysql server container
sudo docker run --name solr-db -d \
    -e MYSQL_ROOT_PASSWORD=my-secret-pw \
    -p 3306:3306 \
    mysql

# Get the sample DB
mkdir data
wget https://github.com/datacharmer/test_db/archive/master.zip
cd data
unzip master.zip
cd ..

# Run mysql client container
sudo docker run -it --rm \
    -v $PWD/data:/data \
    mysql bash

# Import data
cd /data/test_db-master
mysql \
    -h"10.110.202.29" \
    -P"3306" \
    -uroot \
    -p"my-secret-pw" < employees.sql

# Connect to the mysql server
mysql \
    -h"10.110.202.29" \
    -P"3306" \
    -uroot \
    -p"my-secret-pw"

show databases;

use employees;

select * from employees limit 10;
```

Import Data
-----------

```bash
# Make sure that the DB connector libraries are located in the /opt/solr/contrib/dataimporthandler/lib directory.
sudo cp /vagrant/libs/mysql-connector-java-5.1.36-bin.jar .

# Run the Ansible playbook
ansible-playbook ansible/solr-collection.yml \
    -i ansible/hosts/dev
```

Pending
-------

* Madrid propone unos cambios a realizar en la bbdd de SolR (data import etc.), validar conjuntamente con ellos si tienen sentido.