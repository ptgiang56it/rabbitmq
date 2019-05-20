FROM rabbitmq:management-alpine

VOLUME [ "/var/lib/rabbitmq" ]

EXPOSE 15674

WORKDIR /opt/rabbitmq

COPY plugins/* plugins/
RUN rabbitmq-plugins enable rabbitmq_web_stomp
RUN rabbitmq-plugins enable rabbitmq_auth_backend_http
RUN rabbitmq-plugins enable rabbitmq_auth_backend_ip_range

COPY rabbitmq.conf /etc/rabbitmq/
COPY advanced.config /etc/rabbitmq/
COPY rabbitmq-env.conf /etc/rabbitmq/

# RUN rabbitmqctl add_user rabbit rabbit
# RUN rabbitmqctl set_user_tags rabbit administrator
# RUN rabbitmqctl set_permissions -p / rabbit ".*" ".*" ".*"

