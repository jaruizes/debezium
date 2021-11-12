#!/bin/bash

docker-compose -f "${PWD}/../../infra/docker-compose_simple.yaml" --env-file "${PWD}/../../infra/config/.env" down