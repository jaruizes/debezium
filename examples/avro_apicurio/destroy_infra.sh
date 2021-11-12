#!/bin/bash

docker-compose -f "${PWD}/../../infra/docker-compose-avro-apicurio.yaml" --env-file "${PWD}/../../infra/config/.env" down