# Ambari Shell

This docker image aims to get you started with ambari.

## requirement

The only software you need is [docker](docker.io). If you
haven't installed it yet, you need to get out from under that rock
you've been living, and read the
[installation](http://docs.docker.io/introduction/get-docker/) guide.

## start ambari server

You can start a single-node ambari "cluster", with agent and server running
in the same container:

```
docker run -d -P -h server.ambari.com --name ambari-singlenode  sequenceiq/ambari
```

## wait for ambari server

Ambari server needs some time to start up. It will respond with `RUNNING` on the
REST endpoint: `/api/v1/check`. You either wait for 10-20 sec, or
if you prefer to watch a growing dotted line in your terminal:

```
while ! curl --connect-timeout 2 -u admin:admin -H 'Accept: text/plain' $(docker inspect --format "{{.NetworkSettings.IPAddress}}" ambari-singlenode):8080/api/v1/check 2>/dev/null |grep RUNNING &>/dev/null; do echo -n .; sleep 1; done
```

## start ambari-shell

To run ambari shell, you just start a yet another docker container:

```
AMBARI_IP=$(docker inspect --format "{{.NetworkSettings.IPAddress}}" ambari-singlenode)
docker run -it --rm  sequenceiq/ambari-shell --ambari.host=$AMBARI_IP
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
cluster assign --hostGroup host_group_1 --host server.ambari.com
cluster create
tasks
```
