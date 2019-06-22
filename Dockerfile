FROM registry:2

RUN apk update && apk add apache2-utils

ADD config.yml /etc/docker/registry/

ADD htpasswd-entrypoint.sh /

ENTRYPOINT ["/htpasswd-entrypoint.sh"]

CMD ["/etc/docker/registry/config.yml"]
