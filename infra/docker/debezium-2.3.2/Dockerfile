FROM debezium/connect:2.3.2.Final

RUN curl https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.3.2.Final/debezium-connector-postgres-2.3.2.Final-plugin.tar.gz --output /tmp/debezium-connector-postgres-2.3.2.Final-plugin.tar.gz && \
    tar -xf /tmp/debezium-connector-postgres-2.3.2.Final-plugin.tar.gz -C /kafka/connect/debezium-connector-postgres

