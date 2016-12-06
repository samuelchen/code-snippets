#!/bin/sh

# used for official RabbitMQ image

USER=admin
PASSWD=passw0rd

docker run -d --hostname rabbit --name rabbit \
  -p 5672:5672 -p 15672:15672 -p 5671:5671 -p 15671:15671 \
  -e RABBITMQ_DEFAULT_USER=${USER} -e RABBITMQ_DEFAULT_PASS=${PASSWD} rabbitmq:management

echo "Default User: \033[36m ${USER} \033[0m Password: \033[36m ${PASSWD} \033[0m"
