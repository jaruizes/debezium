FROM debezium/connect:1.7

ARG JMX_AGENT_VERSION
RUN mkdir /kafka/etc && cd /kafka/etc &&\
        curl -so jmx_prometheus_javaagent.jar \
        https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/$JMX_AGENT_VERSION/jmx_prometheus_javaagent-$JMX_AGENT_VERSION.jar

COPY monitoring/config.yml /kafka/etc/config.yml

RUN curl https://repo1.maven.org/maven2/io/debezium/debezium-scripting/1.7.0.Final/debezium-scripting-1.7.0.Final.tar.gz --output /tmp/debezium-scripting-1.7.0.Final.tar.gz && \
    tar -xf /tmp/debezium-scripting-1.7.0.Final.tar.gz -C /kafka/connect/debezium-connector-postgres && \
    curl https://repo1.maven.org/maven2/org/codehaus/groovy/groovy-jsr223/3.0.7/groovy-jsr223-3.0.7.jar --output /kafka/connect/debezium-connector-postgres/groovy-jsr223-3.0.7.jar && \
    curl https://repo1.maven.org/maven2/org/codehaus/groovy/groovy/3.0.7/groovy-3.0.7.jar --output /kafka/connect/debezium-connector-postgres/groovy-3.0.7.jar && \
    curl https://repo1.maven.org/maven2/org/codehaus/groovy/groovy-json/3.0.7/groovy-json-3.0.7.jar --output /kafka/connect/debezium-connector-postgres/groovy-json-3.0.7.jar

