FROM rabbitmq:management-alpine

VOLUME [ "/var/lib/rabbitmq" ]

EXPOSE 15674

WORKDIR /opt/rabbitmq


COPY rabbitmq.conf /etc/rabbitmq/
COPY advanced.config /etc/rabbitmq/
COPY rabbitmq-env.conf /etc/rabbitmq/

COPY plugins/* plugins/

COPY setup_rabbit.sh .
RUN chmod 777 setup_rabbit.sh

# CMD ["/opt/rabbitmq/setup_rabbit.sh"]
# RUN rabbitmq-plugins enable rabbitmq_web_stomp
# RUN rabbitmq-plugins enable rabbitmq_auth_backend_http
# RUN rabbitmq-plugins enable rabbitmq_auth_backend_ip_range
