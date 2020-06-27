#!/usr/bin/env bash

#make dummy public and private keys
#the x509 is important for making the system accept a self signed certificate on first startup
openssl req -x509 -nodes -newkey rsa:2048 -keyout ./ssl_stuff/certs/mykey.pem -out ./ssl_stuff/certs/ca-certificates.crt -subj "/C=GB/ST=London/L=London/O=blank/OU=blank/CN=example.com"