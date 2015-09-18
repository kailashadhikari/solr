#!/usr/bin/env bash

# Zookeeper
sudo lokkit --update -p 2181:tcp
sudo lokkit --update -p 2888:tcp
sudo lokkit --update -p 3888:tcp
# Solr
sudo lokkit --update -p 7574:tcp
sudo lokkit --update -p 8983:tcp
