#!/usr/bin/env bash

docker build -t custom-nginx .

docker run --rm -d --name my-custom-nginx-container \
 -p 80:80 \
 -p 8080:8080 \
 -p 443:443 \
 -v $(pwd)/logs:/var/logs/ \
 -v $(pwd)/static-html-directory:/etc/nginx/html \
 -v $(pwd)/ssl_stuff:/etc/ssl \
 -v $(pwd)/letsencrypt:/etc/letsencrypt \
 --name simple-site \
  custom-nginx

#Run the certbot once we have the site up and running with dummy certificates
docker exec simple-site /run_certbot.sh

