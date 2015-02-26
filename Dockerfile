FROM dockerfile/java
MAINTAINER SequenceIQ

RUN apt-get update && apt-get install -y \
    python-pip

RUN pip install requests
RUN curl -Ls https://raw.githubusercontent.com/sequenceiq/ambari-shell/master/latest-snap.sh | bash
ADD install-cluster.sh /tmp/
ADD install-cluster-url.sh /tmp/
ADD install-cluster.py /tmp/
ADD wait-for-host-number.sh /tmp/
WORKDIR /tmp

ENTRYPOINT ["java", "-jar", "ambari-shell.jar"]
