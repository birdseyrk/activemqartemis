# ActiveMQ Artemis

#Latest apline linux
FROM alpine:latest

LABEL maintainer="MSP Integration"

RUN mkdir /artemis
WORKDIR /artemis

ENV ARTEMIS_USER myArtemis
ENV ARTEMIS_PASSWORD myArtemis 
ENV ANONYMOUS false 
ENV EXTRA_ARGS --http-host 0.0.0.0 --relax-jolokia


# This is the queue peristance part
RUN apk add libaio wget

# Download Java Runtime
RUN wget -O "jre14.tar.gz" "https://cdn.azul.com/zulu/bin/zulu14.28.21-ca-jre14.0.1-linux_musl_x64.tar.gz"
RUN tar -xvzf "jre14.tar.gz"

# Link Java Runtime
RUN ln -s /artemis/zulu14.28.21-ca-jre14.0.1-linux_musl_x64/bin/java /usr/bin/java
RUN java --version

# Download activeMQ
RUN wget -O "artemis.tar.gz" "https://www.apache.org/dyn/closer.cgi?filename=activemq/activemq-artemis/2.29.0/apache-artemis-2.29.0-bin.tar.gz&action=download"
RUN tar -xvzf ./artemis.tar.gz; \
	ln -s /artemis/apache-artemis-2.29.0 ./current

#Set JAVA_HOME
ENV JAVA_HOME /artemis/zulu14.28.21-ca-jre14.0.1-linux_musl_x64/

#Create a new broker instance (myArtemis)
RUN /artemis/current/bin/artemis create --user myArtemis --password myArtemis --http-host 0.0.0.0 --require-login --relax-jolokia myArtemis

#Web Server
EXPOSE 8161 \
# JMX Exporter
	9404 \
# Port for CORE, MQTT, AMQP, HORNETO, STOMP, OPENWIRE
	61616 \
# port for HORNETO, STOMP
	5445 \
# port for AMQP 
	5672 \
# Port for MQTT
	1883 \
# port for STOMP 
	61613
	
ENTRYPOINT ["/artemis/myArtemis/bin/artemis", "run"]