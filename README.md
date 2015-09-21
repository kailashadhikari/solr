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

COLLECTION=coll8
SHARDS=2
REPLICATION_FACTOR=2
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

Castellano
==========

Evaluación
----------

* **Failover**: La recomendación es empezar con dos servidores para poder replicar los datos en el caso de "failover".

* **Discovery**: El Zookeeper tendra que tener un número impar de instancias (3). Podemos desplegar dos instancias en los servidores de solr y el tercero a cuanquier otro que tenga GN (ocupa muy pocos recursos).

* **Rendimiento**: Sin hacer pruebas reales no existe manera de descubrir sí "shards" son necesarios o no. En el caso que se descubre que el rendimiento no es adequado, podemos añadir "shards" en nuevas instancias/servidores.

* **Proxy**: Un servicio proxy se usara para automaticamente redirigir las llamadas en caso del fallo de un servidor. El proxy deberia ser instalado en un servidor aparte (puede ser uno de los que ya existen) o se puede usar el servicio existente en el caso que GN tiene ya montado uno.

* **Entorno de desarrollo**: Sí el VirtualBox, Vagrant y Ansible están instalados, entero entorno de desarrollo se puede conseguir ejecutando `vagrant up`. Se crearan tres maquinas virtuales con instancias de **Zookeeper** y **solr** en cada uno de ellos. El procedimiento de crear el entorno de desarrollo es exactamente mismo como el que se usara para desplegar solr/Zookeeper en producción.

* **Despliegue a producción**: Está completamente automatizado con **Ansible** y número flexible de servidores (se pueden añadir o quitar añadiendo IPs al archivo hosts/prod.

Pendiente
---------

* Mecanismo de sincronización entre la base de datos de la aplicación (Zeus) y la nuestra de SolR.

* Madrid propone unos cambios a realizar en la bbdd de SolR (data import etc.), validar conjuntamente con ellos si tienen sentido.