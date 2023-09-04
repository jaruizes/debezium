aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/k9a0b2l8
docker tag debezium-strimzi-postgresql:2.3.2.Final public.ecr.aws/k9a0b2l8/debezium-strimzi-postgresql:2.3.2.Final
docker push public.ecr.aws/k9a0b2l8/debezium-strimzi-postgresql:2.3.2.Final
