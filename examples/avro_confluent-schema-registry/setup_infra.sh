#!/bin/bash

docker-compose -f "${PWD}/../../infra/docker-compose-avro-schemaregistry.yaml" --env-file "${PWD}/../../infra/config/.env" up