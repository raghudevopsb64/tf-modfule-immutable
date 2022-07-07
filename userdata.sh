#!/bin/bash

if [ -f /etc/nginx/default.d/roboshop.conf ]; then
  sed -i -e "s/ENV/${ENV}/" /etc/nginx/default.d/roboshop.conf /etc/filebeat/filebeat.yml
  systemctl restart nginx
  systemctl restart filebeat
  exit
fi

sed -i -e "s/ENV/${ENV}/" -e "s/DOCDB_ENDPOINT/${MONGODB_ENDPOINT}/" /etc/systemd/system/${COMPONENT}.service /etc/filebeat/filebeat.yml

systemctl daemon-reload
systemctl restart ${COMPONENT}
systemctl restart filebeat
