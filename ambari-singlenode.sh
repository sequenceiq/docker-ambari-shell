:<<USAGE
########################################
curl -LOs j.mp/ambari-singlenode && . ambari-singlenode
########################################

full documentation: https://github.com/sequenceiq/docker-ambari-shell
USAGE

docker run -d -p 8080 -h amb0.mycorp.kom --name ambari-singlenode sequenceiq/ambari:latest --tag ambari-server=true
docker run -e BLUEPRINT=single-node-hdfs-yarn --link ambari-singlenode:ambariserver -t --rm --entrypoint /bin/sh sequenceiq/ambari:latest -c /tmp/install-cluster.sh
