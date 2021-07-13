FROM modjular/swarm-gen:latest

LABEL maintainer="Jeffrey Phillips Freeman the@jeffreyfreeman.me"


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

# Configure Nginx and apply fix for very long server names
RUN sed -i 's/worker_processes  1/worker_processes  auto/' /etc/nginx/nginx.conf && \
    mkdir -p /etc/swarm-proxy && \
    mkdir -p /usr/share/swarm-proxy && \
    rm /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh && \
    rm /etc/nginx/nginx.conf && \
    mkdir -p /etc/nginx/serv.d

COPY nginx.conf /etc/nginx/
COPY dhparam.pem.default /etc/swarm-proxy/
COPY generate-dhparam /usr/bin/
COPY swarm-gen.conf /etc/swarm-gen/
COPY swarm-proxy.conf.tmpl /etc/swarm-gen/templates/
COPY https-routing.conf.tmpl /etc/swarm-gen/templates/
COPY 01-copy-default-entry.sh /docker-entrypoint.d/


RUN mkdir -p /etc/nginx/certs && \
    mkdir -p /etc/nginx/dhparam && \
    mkdir -p /etc/nginx/conf.d && \
    mkdir -p /etc/nginx/vhost.d && \
    mkdir -p /etc/nginx/strm.d && \
    mkdir -p /etc/nginx/loc.d

VOLUME ["/etc/nginx/certs", "/etc/nginx/dhparam", "/etc/nginx/conf.d", "/etc/nginx/vhost.d", "/etc/nginx/serv.d", "/etc/nginx/strm.d", "/usr/share/nginx/html"]

ENV DOCKER_HOST unix:///var/run/docker.sock
