#!/bin/bash

if [ -f /etc/nginx/default.d/roboshop.conf ]; then
  sed -i -e 's/ENV/prod/' /etc/nginx/default.d/roboshop.conf /etc/filebeat/filebeat.yml
  systemctl restart nginx
  systemctl restart filebeat
  exit
fi

COMPONENT=$(ls /home/roboshop/)
MONGODB_ENDPOINT=DOCUMENTDB_ENDPOINT

sed -i -e 's/ENV/prod/' -e "s/DOCDB_ENDPOINT/${MONGODB_ENDPOINT}/" /etc/systemd/system/${COMPONENT}.service /etc/filebeat/filebeat.yml

systemctl daemon-reload
systemctl restart ${COMPONENT}
systemctl restart filebeat
