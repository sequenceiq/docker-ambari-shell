FROM dockerfile/java
MAINTAINER MAINTAINER SequenceIQ

RUN curl -Ls https://raw.githubusercontent.com/sequenceiq/ambari-shell/master/latest-snap.sh | bash
WORKDIR /tmp

ENTRYPOINT ["java", "-jar", "ambari-shell.jar"]
