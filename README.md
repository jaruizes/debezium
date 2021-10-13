# Debezium Starter Kit
En este repositorio se puede encontrar una PoC lista para poder empezar a trabajar con Debezium. La versión seleccionada es la 1.7.

## Features
Dentro de las features que podrás encontrar en la PoC se encuentran:

- Entorno local usando Docker Compose
- Replicación desde los siguientes orígenes de datos: MySQL y Postgresql
- Kafka UI para que puedas ver los mensajes de replicación que llegan a Kafka
- Debezium UI, liberada en la versión 1.7 de Debezium, para gestionar los conectores de forma gráfica
- Adminer, para poder realizar cambios en base de datos sin necesitar ningún cliente adicional

<br/>

## Puesta en marcha

La puesta en marcha es muy sencilla. Simplemente tienes que ejecutar:

````shell
docker-compose up -d
````

Una vez levantado todo, tarda unos minutos, tendremos disponibles las siguientes URLs:

- Kakfa (Broker): http://localhost:9092
- Kakfa UI: http://localhost:9081
- Adminer: http://localhost:8080
- Debezium UI: http://localhost:9080
- Kafka Connect: http://localhost:8083

<br/>

<br/>

## Jugando con Debezium

En este momento tenemos levantado el entorno pero no hemos hecho nada con Debezium. 
Si accedemos a la UI de Debezium, nos dirá que no hay ningún conector registrado:

![debezium_empty](doc/img/debezium_empty.jpg)

Si accedemos a la URL de KafkaUI veremos que no hay topics relacionados con replicación con Debezium. Únicamente veremos los relacionados con Kafka Connect:

![debezium_empty](doc/img/topics_empty.jpg)

En los siguientes pasos vamos a ver cómo funciona mediante un ejercicio práctico

<br/>

### Registrando el conector para MySQL
El primer paso es registrar un conector de Debezium para indicar qué queremos establecer CDC desde un orígen a Kafka. El primer origen va a ser MySQL y vamos a registrar el conector mediante el API de Kafka Connect. Para ello, lanzamos a siguiente llamada al API Rest:

````shell
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-mysql.json
````

Deberíamos recibir como respuesta algo como lo siguiente:
````shell
HTTP/1.1 201 Created
Date: Mon, 11 Oct 2021 10:14:12 GMT
Location: http://localhost:8083/connectors/mysql-connector
Content-Type: application/json
Content-Length: 479
Server: Jetty(9.4.39.v20210325)

{"name":"mysql-connector","config":{"connector.class":"io.debezium.connector.mysql.MySqlConnector","tasks.max":"1","database.hostname":"mysql","database.port":"3306","database.user":"debezium","database.password":"dbz","database.server.id":"184054","database.server.name":"mysql","database.include.list":"app1","database.history.kafka.bootstrap.servers":"kafka:9092","database.history.kafka.topic":"mysql-schema-changes.app1","name":"mysql-connector"},"tasks":[],"type":"source"}
````

En la respuesta nos está diciendo que el conector se ha creado correctamente (status 201) y que se ha registrado en "http://localhost:8083/connectors/mysql-connector". Si accedemos ahora al UI de Debezium veremos que nos aparece el conector y que está "running":

![debezium_empty](doc/img/mysql_connector_running.jpg)

Podemos comprobarlo accediendo a Kafka UI. Veremos que aparecen topic nuevos: 

![debezium_empty](doc/img/topics_mysql.jpg)

Si accedemos al topic "mysql.app1.customers", veremos que tiene 4 mensajes:

![debezium_empty](doc/img/mysql_snapshot_messages.jpg)

Estos mensajes no son cambios sino que corresponden al snapshot que ha hecho Debezium de la tabla que hemos configurado en el conector


### Realizando cambios en MySQL

Ahora vamos a hacer cambios en MySQL para ver cómo Debezium lo replica en Kafka. Para ello, accedemos a la [consola de Adminer](http://localhost:8080) e introducimos los datos de conexión a MySQL:
- Servidor: mysql
- User / Pass: user1 / user1
- Base de datos: testdb

![debezium_empty](doc/img/adminer_mysql.jpg)

Una vez dentro, podemos hacer cualquier acción sobre la tabla "customers". Por ejemplo, vamos a añadir un registro:

![debezium_empty](doc/img/©.jpg)

y a editar otro, añadiendo "(Updated) en el nombre":

![debezium_empty](doc/img/mysql_update_customer.jpg)

Si todo ha ido bien, Debezium habrá propagado los cambios a Kafka. Si volvemos ahora a Kafka UI y entramos al topic "mysql.app1.customers" veremos dos mensajes más. El primero, nos indica que se ha insertado un registro (op: c) y los datos del nuevo registro (After):

![debezium_empty](doc/img/mysql_msg_new_customer.jpg)


El segundo nos indica que se ha modificado un registro (op: u), disponiendo en el mensaje de los datos que había antes del cambio (Before) y el resultado del cambio (After):

![debezium_empty](doc/img/mysql_msg_update_customer.jpg)

A partir de aquí, podéis jugar con los datos en MySQL y ver cómo Debezium replica los cambios.

<br/><br/>

### Registrando el conector para Postgresql usando Debezium UI

En este caso no vamos a registrar el conector mediante el API Rest sino que vamos a usar la UI que el equipo de Debezium ha introducido en la última versión. Para ello, accedemos a Debezium UI y veremos que el conector de MySQL está registrado. Para registrar el conector de Postgresql, pulsamos en "Create a Conector" y accederemos al wizard. El primer paso es elegir el tipo de conector (postgresql):

![debezium_empty](doc/img/psql_wizard_1.jpg)

Pulsamos siguiente y pasamos a rellenar los datos del conector. Los podemos sacar del fichero "connectors/register-postgresql.json" de este repositorio (si quisiéramos registrar el conector vía API Rest usaríamos este fichero de la misma forma que lo hicimos con el conector de MySQL). Los datos son:

- **Connector name**: postgresql-connector
- **Namespace**: postgresql
- **Hostname**: postgresql
- **Port**: 5432
- **User**: debezium
- **Password**: dbz
- **Database**: postgresql

En Advanced, elegimos como plugin "pgoutput" ya que nuestro Postgresql de la PoC no dispone de las librerías necesarias para los otros plugins. La pantalla queda así:

![debezium_empty](doc/img/psql_wizard_2.jpg)

Pulsamos "Validate" y si todo está bien pasaremos al paso donde podemos seleccionar qué esquemas y tablas queremos capturar. En nuestro caso, escribimos "app2" en el apartado correspondiente al esquema y pulsamos "Apply" para que tenga en cuenta el esquema seleccionado:

![debezium_empty](doc/img/psql_wizard_3.jpg)

A continuación pulsamos en "Review and Finish" para ir a la pantalla de revisión del conector: 

![debezium_empty](doc/img/psql_wizard_4.jpg)

Por último, pulsamos "Finish" para crear el conector. Nos aparecerá, junto al de MySQL, como "Running":

![debezium_empty](doc/img/psql_wizard_5.jpg)



Si accedemos a [Kafka UI](http://localhost:9081/), veremos que se ha creado un nuevo topic, "postgresql.app2.customers", que contiene cuatro mensajes y que, al igual que en el caso de MySQL, son los correspondientes al snapshot inicial de la información que existe en la tabla "customers"

![debezium_empty](doc/img/topic_psql.jpg)

<br/>

### Realizando cambios en Postgresql

Como hicimos en el apartado correspondiente a MySQL, vamos a hacer cambios en Postgresql para ver cómo Debezium lo replica en Kafka. Para ello, accedemos a la [consola de Adminer](http://localhost:8080) e introducimos los datos de conexión de Postgresql:

- Servidor: postgresql
- User / Pass: user2 / user2
- Base de datos: postgresql

![debezium_empty](doc/img/adminer_psql.jpg)



Una vez dentro tenemos que seleccionar el esquema:

![debezium_empty](doc/img/adminer_psql_esquema.jpg)

Una vez seleccionado, vamos a hacer lo mismo que en el caso de MySQL: crear un registro y modificar otro. Para crear un nuevo registro, hacemos click en customers y luego en "Nuevo Registro":

![debezium_empty](doc/img/adminer_psql_new_record.jpg)

Rellenamos los datos y guardamos:

![debezium_empty](doc/img/adminer_psql_new_customer.jpg)

Por otro lado, modificamos uno existente, añadiendo "(Updated)" en el nombre:

![debezium_empty](doc/img/adminer_psql_update_customer.jpg)

Si todo ha ido correctamente, Debezium habrá propagado los cambios a Kafka. Para comprobarlo, accedemos de nuevo a [Kafka UI](http://localhost:9081/) y en el topic "postgresql.app2.customers" veremos que hay dos mensajes nuevos:

![debezium_empty](doc/img/psql_new_messages.jpg)



El primero, es el correspondiente al nuevo cliente (op "c"), y podemos ver los datos del cliente (After):

![debezium_empty](doc/img/psql_msg_new_customer.jpg)



El segundo, es el correspondiente a la actualización (op: "u") en el que podemos ver el estado anterior al cambio (Before) y los nuevos valores (After):

![debezium_empty](doc/img/psql_msg_update_customer.jpg)



A partir de aquí, podéis jugar con los datos en Postgresql y ver cómo Debezium replica los cambios.

<br/>

## Destruyendo el entorno

Para destruir el entorno, simplemente tenemos que lanzar el comando:

````shell
docker-compose down
````

