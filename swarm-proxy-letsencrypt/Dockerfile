FROM modjular/swarm-gen:latest

LABEL maintainer="Jeffrey Phillips Freeman the@jeffreyfreeman.me"

RUN apt-get -y --no-install-recommends purge nginx

ENV DEBUG=false \
    DOCKER_HOST=unix:///var/run/docker.sock

RUN sync && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      python3 \
      git \
      gcc \
      musl-dev \
      libffi-dev \
      python3-dev \
      libssl-dev \
      procps \
      curl \
      python3-pip && \
    mkdir -p /src && \
    git -C /src clone --depth=1 --branch "0.18.1" https://github.com/zenhack/simp_le.git && \
    cd /src/simp_le && \
    python3 -m pip install -U \
      pip \
      setuptools \
      wheel \
      six && \
    python3 -m pip install . && \
    cd / && \
    rm -rf /src && \
    apt-get purge -y \
      git \
      gcc \
      musl-dev \
      libffi-dev \
      python3-dev \
      libssl-dev && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*


COPY /app/ /app/
COPY swarm-gen.conf /etc/swarm-gen/swarm-gen.conf
COPY swarm-proxy-letsencrypt /usr/bin/
COPY swarm-proxy-letsencrypt-run.sh /docker-run.d/
COPY 99-swarm-proxy-letsencrypt-entry.sh /docker-entrypoint.d/
RUN rm -f /docker-run.d/nginx-run.sh && \
    rm -f /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh && \
    mkdir -p /etc/nginx/certs && \
    mkdir -p /etc/nginx/dhparam && \
    mkdir -p /etc/nginx/conf.d && \
    mkdir -p /etc/nginx/vhost.d && \
    mkdir -p /etc/nginx/loc.d && \
    mkdir -p /usr/share/nginx/html/.well-known/acme-challenge/

VOLUME ["/etc/nginx/certs", "/etc/nginx/dhparam", "/etc/nginx/conf.d", "/etc/nginx/vhost.d", "/usr/share/nginx/html"]

WORKDIR /app
