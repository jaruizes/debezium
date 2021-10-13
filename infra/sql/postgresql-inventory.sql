create schema app2;
alter schema app2 owner to user2;

create table app2.customers
(
    id serial not null constraint customers_pk primary key,
    first_name varchar not null,
    last_name varchar not null,
    email varchar not null
);

ALTER TABLE app2.customers REPLICA IDENTITY FULL;
INSERT INTO app2.customers (first_name, last_name, email) VALUES ('Sally', 'Thomas', 'sally.thomas@acme.com');
INSERT INTO app2.customers (first_name, last_name, email) VALUES ('George', 'Bailey', 'gbailey@foobar.com');
INSERT INTO app2.customers (first_name, last_name, email) VALUES ('Edward', 'Walker', 'ed@walker.com');
INSERT INTO app2.customers (first_name, last_name, email) VALUES ('Anne', 'Kretchmar', 'annek@noanswer.org');

CREATE USER debezium WITH LOGIN REPLICATION ENCRYPTED PASSWORD 'dbz';
grant connect on database postgresql to debezium;
grant usage on schema app2 to debezium;
grant all privileges on all tables in schema app2 to debezium;
GRANT ALL PRIVILEGES ON DATABASE postgresql TO debezium;
grant user2 to debezium;
CREATE PUBLICATION "dbz_publication" FOR ALL TABLES;