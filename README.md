# Ambari and Ambari Shell in Docker

This docker image aims to get you started with [Apache Ambari](http://ambari.apache.org/) and [Ambari Shell](https://github.com/sequenceiq/ambari-shell)

## TL;DR
for the impatient, here is how you bring up a single-node ambari 'cluster', and
use a blueprint to install services
```
docker run -d -p 8080 -h amb0.mycorp.kom --name ambari-singlenode sequenceiq/ambari --tag ambari-server=true
docker run -e BLUEPRINT=single-node-hdfs-yarn --link ambari-singlenode:ambariserver -t --rm --entrypoint /bin/sh sequenceiq/ambari-shell -c /tmp/install-cluster.sh
```

or if you want to have a **one-liner** which fits into a twitter message:
```
curl -LOs j.mp/ambari-singlenode && . ambari-singlenode
```
## requirement

The only software you need is [docker](docker.io). If you
haven't installed it yet, you need to get out from under that rock
you've been living, and read the
[installation](http://docs.docker.io/introduction/get-docker/) guide.

## Get a running Ambari Server url

You need a running Ambari Server where you can connect with ambari shell.
You either:
- Have an already running Ambari Server, for example HDP sandbox.
- You need an Ambari Server **sandbox** you can easily play with, and than discard.

### Option-A: Ambari Server on docker

You can start a single-node ambari "cluster", with agent and server running
in the same container:

```
docker run -d -p 8080 -h amb0.mycorp.kom --name amb0 sequenceiq/ambari --tag ambari-server=true
```

### Option-B: BYOA (Bring You Own Ambari)

You just replace `<HOSTNAME>` with the actual Ambari Server's hostname or IP.
```
docker run -it --rm  sequenceiq/ambari-shell --ambari.host=<HOSTNAME> --ambari.port=<PORT>
```

## Wait for ambari server

Ambari server needs some time to start up. It will respond with `RUNNING` on the
REST endpoint: `/api/v1/check`. You either wait for 10-20 sec, or
if you prefer to watch a growing dotted line in your terminal:

### Option-A: Ambari Server on docker

we have a script prepared inside of the docker image

```
docker run --link amb0:ambariserver -e EXPECTED_HOST_COUNT=1 -it --rm --entrypoint /bin/sh shell -c /tmp/wait-for-host-number.sh
```
Notable parameters

- `--entrypoint /bin/sh` the default entrypoint is to run the ambari-shell java process, it hast to be changed, [read more best practices](http://crosbymichael.com/dockerfile-best-practices.html)
- `-e EXPECTED_HOST_COUNT=1` sets en env variable for the script, it can be omitted
  if you are good with the **default** 1.
- `--link amb0:ambariserver` this will link the container named `amb0` to the container running the script.
  Docker will prepare a couple of env variable with information about the linked amb0. For example: `AMBARISERVER_PORT_8080_TCP_ADDR`
  will point to Ambari Server listen address. This way you don't have to explicitly specify the AMBARI_HOST env variable. Which is
  used in BYOA section.

### option-B: BYOA
if you want to wait for a not dockerized ambari server
```
docker run -e AMBARI_HOST=172.19.0.45 -e EXPECTED_HOST_COUNT=2 -it --rm --entrypoint /bin/sh sequenceiq/ambari-shell -c /tmp/wait-for-host-number.sh
```

## Automated cluster creation

DevOps first please! So the description of the automated cluster installation goes like:
```
docker run -e BLUEPRINT=single-node-hdfs-yarn --link amb0:ambariserver -it --rm --entrypoint /bin/sh sequenceiq/ambari-shell -c /tmp/install-cluster.sh
```

## Start ambari-shell

To run ambari shell, you just start a yet another docker container:

```
AMBARI_IP=$(docker inspect --format "{{.NetworkSettings.IPAddress}}" ambari-singlenode)
docker run -it --rm sequenceiq/ambari-shell --ambari.host=$AMBARI_IP
```

Once the shell is started you will see the following banner
```
    _                _                   _  ____   _            _  _
   / \    _ __ ___  | |__    __ _  _ __ (_)/ ___| | |__    ___ | || |
  / _ \  | '_ ` _ \ | '_ \  / _` || '__|| |\___ \ | '_ \  / _ \| || |
 / ___ \ | | | | | || |_) || (_| || |   | | ___) || | | ||  __/| || |
/_/   \_\|_| |_| |_||_.__/  \__,_||_|   |_||____/ |_| |_| \___||_||_|

Welcome to Ambari Shell. For command and param completion press TAB, for assistance type 'hint'.
ambari-shell>
```

## create a cluster

Now ambari shell is connected to the server and waits for you commands.
The `hint` command can guide you through the process of creating a cluster, but
here are the bare minimum:

```
blueprint defaults
blueprint list
cluster build --blueprint single-node-hdfs-yarn
cluster autoAssign
cluster create
tasks
```
