FROM nginx:1.15-alpine

RUN apk add python3 python3-dev build-base libressl-dev musl-dev libffi-dev

RUN pip3 install pip --upgrade

RUN pip3 install certbot-nginx

RUN mkdir /etc/letsencrypt

COPY ./conf/nginx.conf /etc/nginx/

COPY ./run_certbot.sh /

RUN apk update && apk add bash
