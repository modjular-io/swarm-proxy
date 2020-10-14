FROM modjular/swarm-gen:latest

LABEL maintainer="Jeffrey Phillips Freeman the@jeffreyfreeman.me"

# Configure Nginx and apply fix for very long server names
RUN sed -i 's/worker_processes  1/worker_processes  auto/' /etc/nginx/nginx.conf && \
    mkdir -p /etc/swarm-proxy && \
    mkdir -p /usr/share/swarm-proxy && \
    rm /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh

COPY dhparam.pem.default /etc/swarm-proxy/
COPY generate-dhparam /usr/bin/
COPY swarm-gen.conf /etc/swarm-gen/
COPY swarm-proxy.tmpl /etc/swarm-gen/templates/
COPY 01-copy-default-entry.sh /docker-entrypoint.d/

VOLUME ["/etc/nginx/certs", "/etc/nginx/dhparam", "/etc/nginx/conf.d", "/etc/nginx/vhost.d", "/usr/share/nginx/html"]

ENV DOCKER_HOST unix:///var/run/docker.sock
