#!/bin/bash

set -e

chmod 400 /var/lib/rabbitmq/.erlang.cookie

HOSTNAME=`env hostname`

echo "Hostname is $HOSTNAME"

if [ "$HOSTNAME" = "rabbit1" ]; then
    /usr/local/bin/docker-entrypoint.sh rabbitmq-server
else
    /usr/local/bin/docker-entrypoint.sh rabbitmq-server -detached
    rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
    sleep 5
    rabbitmqctl stop_app
    rabbitmqctl join_cluster rabbit@rabbit1
    rabbitmqctl start_app
    touch test.log && tail -f test.log
fi