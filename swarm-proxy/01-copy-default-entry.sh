#!/bin/bash
set -e

echo "Copying default.conf to conf.d directory"
cat > "/etc/nginx/conf.d/default.conf" << EOF
############################################################################
##                         General Configuration
############################################################################

# If we receive X-Forwarded-Proto, pass it through; otherwise, pass along the
# scheme used to connect to this server
map \$http_x_forwarded_proto \$proxy_x_forwarded_proto {
  default \$http_x_forwarded_proto;
  ''      \$scheme;
}

# If we receive X-Forwarded-Port, pass it through; otherwise, pass along the
# server port the client connected to
map \$http_x_forwarded_port \$proxy_x_forwarded_port {
  default \$http_x_forwarded_port;
  ''      \$server_port;
}

# If we receive Upgrade, set Connection to "upgrade"; otherwise, delete any
# Connection header that may have been passed to this server
map \$http_upgrade \$proxy_connection {
  default upgrade;
  '' close;
}

# Apply fix for very long server names
server_names_hash_bucket_size 128;

# Default dhparam
ssl_dhparam /etc/nginx/dhparam/dhparam.pem;

# Set appropriate X-Forwarded-Ssl header
map \$scheme \$proxy_x_forwarded_ssl {
  default off;
  https on;
}

gzip_types text/plain text/css application/javascript application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

log_format vhost '\$host \$remote_addr - \$remote_user [\$time_local] '
                 '"\$request" \$status \$body_bytes_sent '
                 '"\$http_referer" "\$http_user_agent"';

access_log off;
		ssl_protocols TLSv1.2 TLSv1.3;
		ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384';
		ssl_prefer_server_ciphers off;

#resolver 10.0.0.2;

# HTTP 1.1 support
proxy_http_version 1.1;
proxy_buffering off;
proxy_set_header Host \$http_host;
proxy_set_header Upgrade \$http_upgrade;
proxy_set_header Connection \$proxy_connection;
proxy_set_header X-Real-IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto \$proxy_x_forwarded_proto;
proxy_set_header X-Forwarded-Ssl \$proxy_x_forwarded_ssl;
proxy_set_header X-Forwarded-Port \$proxy_x_forwarded_port;

# Mitigate httpoxy attack (see README for details)
proxy_set_header Proxy "";


############################################################################
##                         Catch all Servers
############################################################################

upstream gitlab_pages_upstream {
  server host.docker.internal:8080;
}

server {
    listen 80 default_server;
    server_name _;

    include /etc/nginx/vhost.d/git.qoto.org*;
    include /etc/nginx/vhost.d/default*;

    location / {
      proxy_pass http://gitlab_pages_upstream;
    }
}


EOF
