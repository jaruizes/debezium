FROM debezium/connect:2.3.2.Final

RUN curl https://repo1.maven.org/maven2/io/debezium/debezium-scripting/2.3.2.Final/debezium-scripting-2.3.2.Final.tar.gz --output /tmp/debezium-scripting-2.3.2.Final.tar.gz && \
    tar -xf /tmp/debezium-scripting-2.3.2.Final.tar.gz -C /kafka/connect/debezium-connector-postgres && \
    curl https://repo1.maven.org/maven2/org/codehaus/groovy/groovy-jsr223/3.0.7/groovy-jsr223-3.0.7.jar --output /kafka/connect/debezium-connector-postgres/groovy-jsr223-3.0.7.jar && \
    curl https://repo1.maven.org/maven2/org/codehaus/groovy/groovy/3.0.7/groovy-3.0.7.jar --output /kafka/connect/debezium-connector-postgres/groovy-3.0.7.jar && \
    curl https://repo1.maven.org/maven2/org/codehaus/groovy/groovy-json/3.0.7/groovy-json-3.0.7.jar --output /kafka/connect/debezium-connector-postgres/groovy-json-3.0.7.jar

