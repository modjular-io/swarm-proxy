FROM modjular/modjular-nginx:1.19.3

LABEL maintainer="Jeffrey Phillips Freeman the@jeffreyfreeman.me"

# Install needed tools
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get dist-upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      sed \
      curl \
      jq \
      software-properties-common \
      gnupg \
      lsb-release && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -y --no-install-recommends install \
      docker-ce \
      docker-ce-cli \
      containerd.io && \
    apt-get purge -y \
      curl \
      lsb-release && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/vhost.d/
RUN mkdir -p /etc/swarm-gen/templates/
COPY swarm-gen.conf /etc/swarm-gen/

COPY swarm-gen-parse-conf /usr/bin
COPY swarm-gen-parse-swarm /usr/bin
COPY swarm-gen-update-state /usr/bin
COPY swarm-gen-check-state /usr/bin
COPY swarm-gen-watch-directories /usr/bin
COPY swarm-gen /usr/bin

COPY swarm-gen-run.sh /docker-run.d/
COPY swarm-gen-watch-directories-run.sh /docker-run.d/
