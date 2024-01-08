#!/bin/bash

set -e

chmod 400 /var/lib/rabbitmq/.erlang.cookie

HOSTNAME=`env hostname`

echo "Hostname is $HOSTNAME"

if [ "$HOSTNAME" = "rabbit1" ]; then
    /usr/local/bin/docker-entrypoint.sh rabbitmq-server
else
    /usr/local/bin/docker-entrypoint.sh rabbitmq-server -detached >> /var/log/rabbitmq/output.log 2>&1
    rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
    rabbitmqctl stop_app
    rabbitmqctl join_cluster rabbit@rabbit1
    rabbitmqctl start_app
    tail -f /var/log/rabbitmq/output.log
fi