#!/bin/bash

rabbitmqctl wait $RABBITMQ_PID_FILE
rabbitmqctl add_vhost users
rabbitmqctl set_permissions --vhost users $RABBITMQ_DEFAULT_USER ".*" ".*" ".*"

rabbitmqadmin declare exchange --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS name=DLX type=topic durable=true internal=true
rabbitmqadmin declare queue --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS name=deadletters durable=true
rabbitmqadmin declare binding --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS source=DLX destination=deadletters routing_key="#"

rabbitmqadmin declare queue --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS name=svc.slice_status durable=true 'arguments={"x-dead-letter-exchange":"DLX"}'
rabbitmqadmin declare binding --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS source=amq.topic destination=svc.slice_status routing_key="slice.status.#"

rabbitmqadmin declare queue --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS name=svc.process_files durable=true 'arguments={"x-dead-letter-exchange":"DLX"}'
rabbitmqadmin declare binding --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS source=amq.topic destination=svc.process_files routing_key="files.#"

rabbitmqadmin declare queue --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS name=svc.slice durable=true 'arguments={"x-dead-letter-exchange":"DLX"}'
rabbitmqadmin declare binding --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS source=amq.headers destination=svc.slice 'arguments={"x-match":"all", "service":"slicer", "slicer":"slic3r"}'

rabbitmqadmin declare queue --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS name=svc.cura_slice durable=true 'arguments={"x-dead-letter-exchange":"DLX"}'
rabbitmqadmin declare binding --user=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS source=amq.headers destination=svc.cura_slice 'arguments={"x-match":"all", "service":"slicer", "slicer":"curaengine"}'
