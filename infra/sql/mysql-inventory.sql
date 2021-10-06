CREATE USER 'replicator' IDENTIFIED BY 'replpass';
CREATE USER 'debezium' IDENTIFIED BY 'dbz';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'replicator';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT  ON *.* TO 'debezium';


-- CREATE DATABASE inventory;
-- GRANT ALL PRIVILEGES ON inventory.* TO 'mysqluser'@'%';
USE app1;

CREATE TABLE customers (
  id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE KEY
) AUTO_INCREMENT=1001;


INSERT INTO customers
VALUES (default,"Sally","Thomas","sally.thomas@acme.com"),
       (default,"George","Bailey","gbailey@foobar.com"),
       (default,"Edward","Walker","ed@walker.com"),
       (default,"Anne","Kretchmar","annek@noanswer.org");