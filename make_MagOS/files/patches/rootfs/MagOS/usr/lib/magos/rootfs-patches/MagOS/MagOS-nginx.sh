#!/bin/bash
PFP=/etc/nginx/nginx.conf
[ -f $PFP ] || exit 0
grep -q magos $PFP && exit 0

mv -f $PFP  $PFP.default

cat >$PFP <<EOF
user  nobody;
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    sendfile        on;
    client_body_buffer_size 1k;
    client_header_buffer_size 1k;
    client_max_body_size 1k;
    large_client_header_buffers 2 1k;
    server_tokens off;
    client_body_timeout 10;
    client_header_timeout 10;
    keepalive_timeout 5 5;
    send_timeout 10;
    server {
        listen       80;
        server_name  localhost.magos-linux.ru;
        location / {
            root   /media/public;
            autoindex on;
            autoindex_localtime on;
#            Block any requests except readind data
            limit_except GET HEAD { deny all; }
#            No connectiont with IP (blocks scanning bots)
#            if ($host !~ ^(ftp.magos-linux.ru)$ ) {
#               return 444;
#            }
        }
        location /favicon.ico {
            alias /usr/share/magos/favicon.ico;
        }
    }
}
EOF
exit 0
